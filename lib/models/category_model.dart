class CategoryModel {
  final int id;
  final String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    try {
      return CategoryModel(
        id: _parseIntFromDynamic(json['id']),
        name: json['name']?.toString() ?? '',
      );
    } catch (e) {
      print('Error parsing CategoryModel: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  // Helper method to safely parse int from dynamic
  static int _parseIntFromDynamic(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) {
      return value.toInt();
    }
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
