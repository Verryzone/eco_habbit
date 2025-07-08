class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email};
  }
}

class ProfileModel {
  final String id;
  final String email;
  final String username;
  final String? imageUrl;

  ProfileModel({
    required this.id,
    required this.email,
    required this.username,
    this.imageUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['user_id'] as String,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? 'User',
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'email': email,
      'username': username,
      'image_url': imageUrl,
    };
  }

  ProfileModel copyWith({
    String? id,
    String? email,
    String? username,
    String? imageUrl,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
