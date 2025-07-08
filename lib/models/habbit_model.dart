class HabbitModel {
  final int id;
  final String name;

  HabbitModel({required this.id, required this.name});

  factory HabbitModel.fromJson(Map<String, dynamic> json) {
    return HabbitModel(id: json['id'] as int, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
    };
  }
}
