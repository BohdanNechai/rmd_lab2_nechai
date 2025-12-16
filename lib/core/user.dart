class AppUser {
  final String name;
  final String email;
  final String password;

  const AppUser({required this.name, required this.email, required this.password});

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'password': password};

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }
}
