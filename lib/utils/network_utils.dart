import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NetworkUtils {
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 10));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      print('Internet connectivity check failed: $e');
      return false;
    }
  }

  static Future<bool> canReachSupabase() async {
    try {
      final client = Supabase.instance.client;
      
      // Simple health check - try to get a count from any table
      await client
          .from('profiles')
          .select('count')
          .count(CountOption.exact)
          .timeout(const Duration(seconds: 15));
      
      print('Supabase connection successful');
      return true;
    } catch (e) {
      print('Supabase connection failed: $e');
      return false;
    }
  }

  static Future<void> showConnectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Issue'),
          content: const Text(
            'Unable to connect to the server. Please check your internet connection and try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void showConnectionSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // User can implement retry logic
          },
        ),
      ),
    );
  }
}
