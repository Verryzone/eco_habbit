import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eco_habbit/controllers/dashboard_controller.dart';
import 'package:eco_habbit/controllers/profile_controller.dart';
import 'dart:io';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoggedIn() {
    return supabase.auth.currentSession != null;
  }

  String? getCurrentUserId() {
    return supabase.auth.currentUser?.id;
  }

  Future<void> signUp(String name, String email, String password) async {
    try {
      print('Starting sign up process for: $email');
      
      // Check internet connectivity first
      await _checkConnectivity();
      
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection and try again.');
        },
      );

      print('Sign up response received: ${response.user?.id}');

      if (response.user == null) {
        throw Exception('User registration failed. Please try again or check your email for verification.');
      }
      
      // Clear any existing data when new user signs up
      DashboardController().clearData();
      print('Sign up successful for: $email');
      
    } catch (e) {
      print('Sign up error: $e');
      
      // Handle specific error types
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network and try again.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Connection timeout. Please try again with a better internet connection.');
      } else if (e.toString().contains('already registered')) {
        throw Exception('Email is already registered. Please try logging in instead.');
      } else {
        throw Exception('Sign Up failed: Please check your internet connection and try again.');
      }
    }
  }

  Future<void> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 10),
      );
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw Exception('No internet connection');
      }
    } catch (e) {
      throw Exception('No internet connection. Please check your network settings.');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      print('Starting sign in process for: $email');
      
      // Check internet connectivity first
      await _checkConnectivity();
      
      await supabase.auth.signInWithPassword(
        email: email, 
        password: password
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection and try again.');
        },
      );
      
      print('Sign in successful for: $email');
      
      // Clear existing data and reinitialize for the new user
      DashboardController().clearData();
    } catch (e) {
      print('Sign in error: $e');
      
      // Handle specific error types
      if (e.toString().contains('Failed host lookup') || 
          e.toString().contains('SocketException')) {
        throw Exception('No internet connection. Please check your network and try again.');
      } else if (e.toString().contains('timeout')) {
        throw Exception('Connection timeout. Please try again with a better internet connection.');
      } else if (e.toString().contains('Invalid login credentials')) {
        throw Exception('Invalid email or password. Please check your credentials.');
      } else {
        throw Exception('Sign-in failed: Please check your internet connection and try again.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      // Clear data before signing out
      DashboardController().clearData();
      ProfileController().clearProfile();
      
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }
}
