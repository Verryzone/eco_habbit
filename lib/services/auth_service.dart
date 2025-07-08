import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eco_habbit/controllers/dashboard_controller.dart';
import 'package:eco_habbit/controllers/profile_controller.dart';

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
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );

      if (response.user == null) {
        throw Exception('User not created');
      }
      
      // Clear any existing data when new user signs up
      DashboardController().clearData();
    } catch (e) {
      throw Exception('Sign Up failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
      
      // Clear existing data and reinitialize for the new user
      DashboardController().clearData();
    } catch (e) {
      throw Exception('Sign-in failed: $e');
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
