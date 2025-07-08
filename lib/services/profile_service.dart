import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eco_habbit/models/user_model.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;
  static const String bucketName = 'profiles-images';

  Future<ProfileModel?> getProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response == null) {
        // Create default profile if doesn't exist
        await _createDefaultProfile(user.id, user.email ?? '');
        return ProfileModel(
          id: user.id,
          email: user.email ?? '',
          username: 'User',
          imageUrl: null,
        );
      }

      return ProfileModel(
        id: response['user_id'],
        email: user.email ?? '',
        username: response['username'] ?? 'User',
        imageUrl: response['image_url'],
      );
    } catch (e) {
      throw Exception('Failed to get profile: $e');
    }
  }

  Future<void> _createDefaultProfile(String userId, String email) async {
    try {
      await supabase.from('profiles').insert({
        'user_id': userId,
        'username': email.split('@').first,
        'image_url': null,
      });
    } catch (e) {
      print('Error creating default profile: $e');
    }
  }

  Future<String> uploadProfileImage(Uint8List imageBytes, String fileName) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileExtension = fileName.split('.').last.toLowerCase();
      final uniqueFileName = '${user.id}_$timestamp.$fileExtension';

      print('Uploading image: $uniqueFileName'); // Debug log

      // Try uploading to specific bucket
      const bucketOptions = ['profiles-images', 'profile-images', 'avatars', 'images', 'public'];
      String? successfulUrl;
      
      for (final bucket in bucketOptions) {
        try {
          print('Trying bucket: $bucket');
          
          // Upload to Supabase Storage
          await supabase.storage
              .from(bucket)
              .uploadBinary(uniqueFileName, imageBytes, 
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: true,
                )
              );

          // Get public URL
          final imageUrl = supabase.storage
              .from(bucket)
              .getPublicUrl(uniqueFileName);

          print('Successfully uploaded to $bucket: $imageUrl');
          successfulUrl = imageUrl;
          break; // Success, exit loop
          
        } catch (e) {
          print('Failed to upload to bucket $bucket: $e');
          continue; // Try next bucket
        }
      }

      if (successfulUrl == null) {
        throw Exception('Failed to upload to any available bucket');
      }

      return successfulUrl;
    } catch (e) {
      print('Upload error: $e'); // Debug log
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> updateProfile({String? username, String? imageUrl}) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      
      if (updates.isNotEmpty) {
        updates['update_at'] = DateTime.now().toIso8601String();
        
        print('Updating profile with: $updates'); // Debug log
        
        await supabase
            .from('profiles')
            .update(updates)
            .eq('user_id', user.id);
            
        print('Profile updated successfully'); // Debug log
      }
    } catch (e) {
      print('Update profile error: $e'); // Debug log
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> updateProfileImage(Uint8List imageBytes, String fileName) async {
    try {
      // Upload new image
      final imageUrl = await uploadProfileImage(imageBytes, fileName);
      
      // Update profile with new image URL
      await updateProfile(imageUrl: imageUrl);
    } catch (e) {
      throw Exception('Failed to update profile image: $e');
    }
  }

  // Debug method to test storage connection
  Future<void> testStorageConnection() async {
    try {
      print('Testing storage connection...');
      
      // List all buckets
      final buckets = await supabase.storage.listBuckets();
      print('Available buckets: ${buckets.map((b) => b.name).toList()}');
      
      // Try to access our specific bucket
      try {
        final files = await supabase.storage.from(bucketName).list();
        print('Files in $bucketName: ${files.length} files');
      } catch (e) {
        print('Error accessing $bucketName: $e');
        print('Bucket might not exist, will try to create it');
      }
      
    } catch (e) {
      print('Storage connection test failed: $e');
    }
  }
}
