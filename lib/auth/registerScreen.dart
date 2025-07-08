import 'dart:js_interop';

import 'package:eco_habbit/auth/loginScreen.dart';
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

  final Color primaryColor = const Color(0xFF54861C);

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
                      onPressed: () {
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
                      onPressed: () {
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
                      onChanged: (value) {
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
                    onPressed: () async {
                      if (_passwordController.text ==
                          _confirmPasswordController.text) {
                        try {
                          await _authService.signUp(
                            _nameController.text,
                            _emailController.text,
                            _passwordController.text,
                          );

                          Get.to(
                            () => ButtonNavbarScreen(),
                            transition: Transition.fadeIn,
                            duration: Duration(milliseconds: 400),
                          );
                        } catch (e) {
                          Get.snackbar(
                            "Error",
                            e.toString(),
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.TOP,
                            margin: EdgeInsets.only(top: 4, right: 4, left: 4),
                          );
                        }
                      } else {
                        Get.snackbar(
                          "Warning",
                          "Password doesn't match!",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.TOP,
                          margin: EdgeInsets.only(top: 4, right: 4, left: 4),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Haved an account?', style: TextStyle(fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        // Get.to(
                        //   () => LoginScreen(),
                        //   transition: Transition.circularReveal,
                        //   duration: Duration(milliseconds: 2000),
                        // );
                        Get.back();
                      },
                      child: Text(
                        ' Login',
                        style: TextStyle(
                          color: primaryColor,
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
