// class HabbitModel {
//   final int id;
//   final int userId;
//   final String name;
//   final int categoryId;
//   final String date;
//   final String createdAt;

//   HabbitModel({
//     required this.id,
//     required this.userId,
//     required this.name,
//     required this.categoryId,
//     required this.date,
//     required this.createdAt,
//   });

//   factory HabbitModel.fromJson(Map<String, dynamic> json) {
//     return HabbitModel(
//       id: json['id'] as int,
//       userId: json['userId'] as int,
//       name: json['name'] as String,
//       categoryId: json['category_id'] as int,
//       date: json['date'] as String,
//       createdAt: DateTime.parse(json['created_at']) as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'name': name,
//       'category_id': categoryId,
//       'date': date,
//       'created_at': createdAt,
//     };
//   }
// }
class HabbitModel {
  final String? id; // Changed to String to match UUID from Supabase
  final String? userId; // Changed to String to match UUID
  final String name;
  final int? categoryId;
  final String date;
  final String createdAt;

  HabbitModel({
    this.id,
    this.userId,
    required this.name,
    this.categoryId,
    required this.date,
    required this.createdAt,
  });

  factory HabbitModel.fromJson(Map<String, dynamic> json) {
    try {
      return HabbitModel(
        id: _parseStringFromDynamic(json['id']),
        userId: _parseStringFromDynamic(json['user_id']),
        name: json['name']?.toString() ?? '',
        categoryId: _parseIntFromDynamic(json['category_id']),
        date: json['date']?.toString() ?? '',
        createdAt: json['created_at']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing HabbitModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Helper method to safely parse String from dynamic
  static String? _parseStringFromDynamic(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }

  // Helper method to safely parse int from dynamic
  static int? _parseIntFromDynamic(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is double) {
      return value.toInt();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'category_id': categoryId,
      'date': date,
      'created_at': createdAt,
    };
  }
}
