import 'dart:async';
import 'package:eco_habbit/models/habbit_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// class HabbitService {
//   final SupabaseClient supabase = Supabase.instance.client;

//   Future<List<HabbitModel>> fetchHabbits() async {
//     try {
//       final response = await supabase
//           .from('habbits')
//           .select()
//           .eq('user_id', supabase.auth.currentUser!.id);
//       return response.map((json) => HabbitModel.fromJson(json)).toList();
//     } catch (e) {
//       throw Exception('Gagal mengambil kebiasaan: $e');
//     }
//   }

//   Future<void> createHabit(String name, int categoryId) async {
//     try {
//       await supabase.from('habbits').insert({
//         'user_id': supabase.auth.currentUser!.id,
//         'name': name,
//         'category_id': categoryId,
//       });
//     } catch (e) {
//       throw Exception('Gagal menambah kebiasaan: $e');
//     }
//   }

//   Future<void> updateHabit(int id, String name) async {
//     try {
//       await supabase.from('habbits').update({'name': name}).eq('id', id);
//     } catch (e) {
//       throw Exception('Gagal memperbarui kebiasaan: $e');
//     }
//   }

//   Future<void> deleteHabit(int id) async {
//     try {
//       await supabase.from('habbits').delete().eq('id', id);
//     } catch (e) {
//       throw Exception('Gagal menghapus kebiasaan: $e');
//     }
//   }
// }
class HabbitService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<HabbitModel>> fetchHabbits() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      
      // Add timeout for better user experience
      final response = await supabase
          .from('habbits')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false) // Sort by newest first
          .timeout(const Duration(seconds: 10));
      
      return response.map((json) => HabbitModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil kebiasaan: $e');
    }
  }

  Future<void> createHabit(String name, int categoryId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      
      await supabase.from('habbits').insert({
        'user_id': user.id,
        'name': name,
        'category_id': categoryId,
      }).timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Gagal menambah kebiasaan: $e');
    }
  }

  Future<void> updateHabit(String id, String name) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        throw Exception('Invalid ID format: $id');
      }
      
      await supabase
          .from('habbits')
          .update({'name': name})
          .eq('id', intId)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Gagal memperbarui kebiasaan: $e');
    }
  }

  Future<void> updateHabitWithCategory(String id, String name, int categoryId) async {
    try {
      final intId = int.tryParse(id);
      if (intId == null) {
        throw Exception('Invalid ID format: $id');
      }
      
      await supabase
          .from('habbits')
          .update({
            'name': name,
            'category_id': categoryId,
          })
          .eq('id', intId)
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      throw Exception('Gagal memperbarui kebiasaan: $e');
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      // Check if user is authenticated
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }
      
      // Convert string ID to int since database uses int ID
      final intId = int.tryParse(id);
      if (intId == null) {
        throw Exception('Invalid ID format: $id');
      }
      
      // First, let's check if the habit exists and belongs to the user
      final existingHabit = await supabase
          .from('habbits')
          .select()
          .eq('id', intId)
          .eq('user_id', user.id)
          .maybeSingle()
          .timeout(const Duration(seconds: 5));
      
      if (existingHabit == null) {
        throw Exception('Habit not found or does not belong to current user');
      }
      
      // Perform the delete operation
      await supabase
          .from('habbits')
          .delete()
          .eq('id', intId)
          .eq('user_id', user.id) // Also check user_id for security
          .timeout(const Duration(seconds: 10));
      
    } catch (e) {
      throw Exception('Gagal menghapus kebiasaan: $e');
    }
  }
}
