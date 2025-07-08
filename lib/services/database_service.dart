import 'dart:async';
import 'package:eco_habbit/models/habbit_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future <List<HabbitModel>> fetchHabbit() async {
    try {
      final response = await supabase.from('habbits').select();
      return response.map((json) => HabbitModel.fromJson(json)).toList();
    } catch(e) {
      throw Exception('Failed to fetch habbits: $e');
    }
  }
}