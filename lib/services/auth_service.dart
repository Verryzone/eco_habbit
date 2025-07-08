import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:eco_habbit/config/env.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;

  bool isLoggedIn() {
    return supabase.auth.currentSession != null;
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
    } catch (e) {
      throw Exception('Sign Up failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await supabase.auth.signInWithPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }
}
