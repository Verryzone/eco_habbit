import 'package:eco_habbit/auth/registerScreen.dart';
import 'package:eco_habbit/pages/buttomNavbarScreen.dart';
import 'package:eco_habbit/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (_authService.isLoggedIn()) {
      Future.microtask(() {
        Get.offAll(() => ButtonNavbarScreen());
      });
    }
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.only(top: 4, right: 4, left: 4),
      );
      return;
    }

    try {
      _setLoading(true);
      await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      
      // Small delay to show loading animation
      await Future.delayed(const Duration(milliseconds: 500));
      
      Get.offAll(
        () => ButtonNavbarScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 400),
      );
    } catch (e) {
      Get.snackbar(
        "Login Failed",
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/hutan.jpg',
                    width: 1000,
                    height: 250,
                    fit: BoxFit.fitWidth,
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Text(
                        'Welcome!',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    enabled: !_isLoading,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xFF54861C), width: 2),
                      ),
                      focusColor: const Color(0xFF54861C),
                    ),
                    cursorColor: const Color(0xFF54861C),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    enabled: !_isLoading,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color(0xFF54861C),
                          width: 2,
                        ),
                      ),
                      focusColor: const Color(0xFF54861C),
                    ),
                    obscureText: true,
                    cursorColor: const Color(0xFF54861C),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _isLoading ? null : () {
                            // TODO: Implement forgot password
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: _isLoading 
                                  ? Colors.grey 
                                  : const Color(0xFF54861C),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      backgroundColor: const Color(0xFF54861C),
                      disabledBackgroundColor: const Color(0xFF54861C).withOpacity(0.6),
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
                                'Logging in...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: _isLoading ? null : () {
                          Get.to(
                            () => RegisterScreen(),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 600),
                          );
                        },
                        child: Text(
                          ' Register Now',
                          style: TextStyle(
                            color: _isLoading 
                                ? Colors.grey 
                                : const Color(0xFF54861C),
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
        ],
      ),
    );
  }
}
