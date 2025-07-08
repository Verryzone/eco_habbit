import 'dart:async';
import 'dart:typed_data';
import 'package:eco_habbit/models/user_model.dart';
import 'package:eco_habbit/services/profile_service.dart';

class ProfileController {
  static final ProfileController _instance = ProfileController._internal();
  factory ProfileController() => _instance;
  ProfileController._internal();

  final ProfileService _profileService = ProfileService();

  // Data state
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;
  bool _isProfileLoaded = false; // Flag to track if profile has been loaded

  // Streams for reactive updates
  final StreamController<ProfileModel?> _profileController = 
      StreamController<ProfileModel?>.broadcast();
  final StreamController<bool> _loadingController = 
      StreamController<bool>.broadcast();
  final StreamController<String?> _errorController = 
      StreamController<String?>.broadcast();

  // Getters for streams
  Stream<ProfileModel?> get profileStream => _profileController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<String?> get errorStream => _errorController.stream;

  // Getters for current data
  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isProfileLoaded => _isProfileLoaded;

  Future<void> loadProfile({bool forceReload = false}) async {
    // Skip loading if profile is already loaded and not forcing reload
    if (_isProfileLoaded && !forceReload && _profile != null) {
      print('Profile already cached, skipping reload'); // Debug log
      _profileController.add(_profile); // Emit cached data
      return;
    }

    _setLoading(true);
    _setError(null);

    try {
      _profile = await _profileService.getProfile();
      _isProfileLoaded = true;
      _profileController.add(_profile);
      print('Profile loaded and cached'); // Debug log
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateUsername(String username) async {
    if (_profile == null) return;

    final oldProfile = _profile;
    
    try {
      _setLoading(true);
      
      // Optimistic update
      _profile = _profile!.copyWith(username: username);
      _profileController.add(_profile);
      
      // Update in backend
      await _profileService.updateProfile(username: username);
    } catch (e) {
      // Rollback on error
      _profile = oldProfile;
      _profileController.add(_profile);
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfileImage(Uint8List imageBytes, String fileName) async {
    if (_profile == null) return;

    try {
      _setLoading(true);
      print('Starting profile image update...'); // Debug log
      
      // Upload image and update profile
      await _profileService.updateProfileImage(imageBytes, fileName);
      print('Image upload completed, updating cached profile...'); // Debug log
      
      // Force reload profile to get new image URL
      final updatedProfile = await _profileService.getProfile();
      if (updatedProfile != null) {
        _profile = updatedProfile;
        _isProfileLoaded = true; // Keep cache flag true
        print('Cached profile updated with new image: ${_profile?.imageUrl}'); // Debug log
        
        // Clear error if any
        _setError(null);
        
        // Force update stream immediately
        _profileController.add(_profile);
        
        // Add a small delay and update again to ensure UI refresh
        await Future.delayed(const Duration(milliseconds: 100));
        _profileController.add(_profile);
      }
      
    } catch (e) {
      print('Profile image update error: $e'); // Debug log
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void clearProfile() {
    _profile = null;
    _isProfileLoaded = false; // Reset cache flag
    _setError(null);
    _profileController.add(_profile);
    print('Profile cache cleared'); // Debug log
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    _loadingController.add(_isLoading);
  }

  void _setError(String? error) {
    _error = error;
    _errorController.add(_error);
  }

  void dispose() {
    _profileController.close();
    _loadingController.close();
    _errorController.close();
  }
}
