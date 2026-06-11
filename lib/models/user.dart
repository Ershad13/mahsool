class User {
  final int id;
  final String username;
  final String role;
  final String fullName;

  User({
    required this.id,
    required this.username,
    required this.role,
    required this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      role: json['role'],
      fullName: json['full_name'] ?? '',
    );
  }
}
