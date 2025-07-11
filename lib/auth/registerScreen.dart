import 'package:eco_habbit/pages/buttomNavbarScreen.dart';
import 'package:eco_habbit/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  bool agreeTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  final Color primaryColor = const Color(0xFF54861C);

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> _handleRegister() async {
    // Validation
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        "Warning",
        "Please fill all fields",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (!agreeTerms) {
      Get.snackbar(
        "Warning",
        "Please agree to Terms and Conditions",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      Get.snackbar(
        "Warning",
        "Password doesn't match!",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
        duration: const Duration(seconds: 3),
      );
      return;
    }

    _setLoading(true);

    try {
      await _authService.signUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      Get.snackbar(
        "Success",
        "Account created successfully!",
        backgroundColor: primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
        duration: const Duration(seconds: 2),
      );

      // Navigate to main screen
      Get.offAll(
        () => ButtonNavbarScreen(),
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
        duration: const Duration(seconds: 3),
      );
    } finally {
      _setLoading(false);
    }
  }

  OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: color),
    );
  }

  @override
  void initState() {
    super.initState();

    if (_authService.isLoggedIn()) {
      Future.microtask(() {
        Get.offAll(() => ButtonNavbarScreen());
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 36.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Create an account to get started',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextField(
                  enabled: !_isLoading,
                  cursorColor: primaryColor,
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: _inputBorder(Colors.grey).copyWith(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: _inputBorder(primaryColor).copyWith(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextField(
                  enabled: !_isLoading,
                  cursorColor: primaryColor,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: _inputBorder(Colors.grey).copyWith(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: _inputBorder(primaryColor).copyWith(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextField(
                  enabled: !_isLoading,
                  cursorColor: primaryColor,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: _inputBorder(Colors.grey).copyWith(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: _inputBorder(primaryColor).copyWith(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
                SizedBox(height: 20),
                TextField(
                  enabled: !_isLoading,
                  cursorColor: primaryColor,
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: _isLoading ? null : () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: _inputBorder(Colors.grey).copyWith(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    focusedBorder: _inputBorder(primaryColor).copyWith(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                  obscureText: _obscureConfirmPassword,
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: agreeTerms,
                      activeColor: primaryColor,
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          agreeTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 0,
                        children: [
                          const Text(
                            'I\'ve read and agree with the ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Terms and Conditions',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                          const Text(
                            ' and the ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Privacy Policy.',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: primaryColor,
                      disabledBackgroundColor: primaryColor.withOpacity(0.6),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Creating Account...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : () {
                        Get.back();
                      },
                      child: Text(
                        ' Login',
                        style: TextStyle(
                          color: _isLoading ? Colors.grey : primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
