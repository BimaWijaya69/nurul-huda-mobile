class User {
  final int id;
  final String name;
  final String username;
  final String role;
  final String? kodeGuru;
  final String? deviceId;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    this.kodeGuru,
    this.deviceId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? 'guru',
      kodeGuru: json['kode_guru'],
      deviceId: json['device_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'role': role,
        'kode_guru': kodeGuru,
        'device_id': deviceId,
      };
}

class AuthResponse {
  final String status;
  final String message;
  final User? user;
  final String? token;

  AuthResponse({
    required this.status,
    required this.message,
    this.user,
    this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'],
      message: json['message'],
      user: json['data'] != null ? User.fromJson(json['data']['user']) : null,
      token: json['data'] != null ? json['data']['token'] : null,
    );
  }
}
