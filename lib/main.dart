import 'package:eco_habbit/config/env.dart';
import 'package:eco_habbit/pages/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');
    print('Environment loaded successfully');
    
    // Initialize Supabase with proper configuration
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      anonKey: AppEnv.supabaseAnonKey,
      debug: true, // Enable debug mode
    ).timeout(
      const Duration(seconds: 45), // Overall timeout for initialization
      onTimeout: () {
        print('Supabase initialization timed out');
        throw Exception('Supabase initialization timeout');
      },
    );
    
    print('Supabase initialized successfully');
    print('Supabase URL: ${AppEnv.supabaseUrl}');
    
  } catch (e) {
    print('Error in main initialization: $e');
    // App will still run but with limited functionality
  }
  
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Splashscreen()
      ),
    );
  }
}
