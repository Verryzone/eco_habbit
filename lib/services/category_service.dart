import 'dart:async';
import 'package:eco_habbit/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoryService {
  final SupabaseClient supabase = Supabase.instance.client;

  List<String> actionList = [];
  bool isLoading = true;

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select('id, name');
      
      return response.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      print('Error in fetchCategories: $e');
      throw Exception('Gagal mengambil categories: $e');
    }
  }
}
