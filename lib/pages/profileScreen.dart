import 'dart:typed_data';
import 'package:eco_habbit/auth/loginScreen.dart';
import 'package:eco_habbit/services/auth_service.dart';
import 'package:eco_habbit/controllers/profile_controller.dart';
import 'package:eco_habbit/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final ProfileController _profileController = ProfileController();
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profile only if not already cached
    _profileController.loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        
        // Show loading indicator
        print('Starting image upload...'); // Debug log
        
        // Upload and update profile image
        await _profileController.updateProfileImage(imageBytes, image.name);
        
        print('Image upload completed'); // Debug log
        
        // Force multiple UI rebuilds to ensure refresh
        if (mounted) {
          setState(() {});
          // Add small delay and setState again
          await Future.delayed(const Duration(milliseconds: 200));
          if (mounted) {
            setState(() {});
          }
        }
        
        Get.snackbar(
          "Success",
          "Profile image updated successfully!",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('Image upload error: $e'); // Debug log
      Get.snackbar(
        "Error",
        "Failed to update profile image: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
      );
    }
  }

  Future<void> _editUsername(ProfileModel profile) async {
    _usernameController.text = profile.username;
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Username'),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green.shade600, width: 2),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, _usernameController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != profile.username) {
      await _profileController.updateUsername(result);
      Get.snackbar(
        "Success",
        "Username updated successfully!",
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF54861C);
    final Color lightGreen = const Color(0xFFC2D9AB);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, color: primaryColor),
            onPressed: () async {
              try {
                await _authService.signOut();
                Get.offAll(
                  () => const LoginScreen(),
                  transition: Transition.fadeIn,
                  duration: const Duration(milliseconds: 400),
                );
              } catch (e) {
                Get.snackbar(
                  "Error",
                  e.toString(),
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<ProfileModel?>(
          stream: _profileController.profileStream,
          initialData: _profileController.profile,
          builder: (context, profileSnapshot) {
            return StreamBuilder<bool>(
              stream: _profileController.loadingStream,
              initialData: _profileController.isLoading,
              builder: (context, loadingSnapshot) {
                final isLoading = loadingSnapshot.data ?? false;
                final profile = profileSnapshot.data;

                return CustomScrollView(
                  slivers: [
                    // Profile Header
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            // Avatar + edit icon
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                GestureDetector(
                                  onTap: isLoading ? null : _pickAndUploadImage,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 110,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: lightGreen,
                                          border: Border.all(
                                            color: primaryColor.withOpacity(0.2),
                                            width: 3,
                                          ),
                                        ),                        child: profile?.imageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  '${profile!.imageUrl!}?t=${DateTime.now().millisecondsSinceEpoch}', // Cache busting with timestamp
                                  key: ValueKey('profile_image_${profile.imageUrl}_${DateTime.now().millisecondsSinceEpoch}'), // Unique key for rebuild
                                  width: 104,
                                  height: 104,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Image load error: $error'); // Debug log
                                    return Icon(
                                      Icons.person,
                                      size: 60,
                                      color: primaryColor,
                                    );
                                  },
                                ),
                              )
                                            : Icon(
                                                Icons.person, 
                                                size: 60, 
                                                color: primaryColor
                                              ),
                                      ),
                                      // Loading overlay for upload
                                      if (isLoading)
                                        Container(
                                          width: 104,
                                          height: 104,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black.withOpacity(0.5),
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 3,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Edit button
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Name with edit functionality
                            GestureDetector(
                              onTap: profile != null && !isLoading 
                                  ? () => _editUsername(profile)
                                  : null,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: primaryColor.withOpacity(0.2)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      profile?.username ?? "Loading...",
                                      style: TextStyle(
                                        fontSize: 18, 
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Email
                            Text(
                              profile?.email ?? "Loading...",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                    // Menu List
                    SliverToBoxAdapter(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMenuTile(
                              "Habit Total",
                              Icons.check_circle_outline,
                              primaryColor,
                              () {
                                // TODO: Navigate to habit statistics
                              },
                            ),
                            _buildDivider(),
                            _buildMenuTile(
                              "Activity Rating",
                              Icons.star_outline,
                              Colors.orange,
                              () {
                                // TODO: Navigate to ratings
                              },
                            ),
                            _buildDivider(),
                            _buildMenuTile(
                              "Devices",
                              Icons.devices_outlined,
                              Colors.blue,
                              () {
                                // TODO: Navigate to devices
                              },
                            ),
                            _buildDivider(),
                            _buildMenuTile(
                              "Notifications",
                              Icons.notifications_outlined,
                              Colors.purple,
                              () {
                                // TODO: Navigate to notifications settings
                              },
                            ),
                            _buildDivider(),
                            _buildMenuTile(
                              "Appearance",
                              Icons.palette_outlined,
                              Colors.pink,
                              () {
                                // TODO: Navigate to appearance settings
                              },
                            ),
                            _buildDivider(),
                            _buildMenuTile(
                              "Language",
                              Icons.language_outlined,
                              Colors.indigo,
                              () {
                                // TODO: Navigate to language settings
                              },
                            ),
                            _buildDivider(),
                            _buildMenuTile(
                              "Privacy & Security",
                              Icons.security_outlined,
                              Colors.red,
                              () {
                                // TODO: Navigate to privacy settings
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom spacing
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 30),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Widget helper for menu items with icon and color
  Widget _buildMenuTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(left: 80),
      height: 1,
      color: Colors.grey[100],
    );
  }
}
