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
      body: Padding(
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
              SizedBox(height: 15),
              Row(
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xFF54861C), width: 2),
                  ),
                  focusColor: Color(0xFF54861C),
                ),
                cursorColor: Color(0xFF54861C),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: Color(0xFF54861C),
                      width: 2, // Tambahkan ketebalan border
                    ),
                  ),
                  focusColor: Color(0xFF54861C),
                ),
                obscureText: true,
                cursorColor: Color(0xFF54861C),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF54861C),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _authService.signIn(
                      _emailController.text,
                      _passwordController.text,
                    );
                    Get.to(
                      () => ButtonNavbarScreen(),
                      transition: Transition.fadeIn,
                      duration: Duration(milliseconds: 400),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Color(0xFF54861C),
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => RegisterScreen(),
                        transition: Transition.rightToLeft, // animasi slide
                        duration: Duration(milliseconds: 600),
                      );
                    },
                    child: Text(
                      ' Register Now',
                      style: TextStyle(
                        color: Color(0xFF54861C),
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
    );
  }
}
