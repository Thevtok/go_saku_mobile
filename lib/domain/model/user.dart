// ignore_for_file: non_constant_identifier_names

class User {
  String? ID;
  final String name;
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  int balance;
  int point;
  String? token;
  String role;
  int? badgeID;
  String? badgeName;
  int? txCount;

  User({
    this.ID,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.address,
    this.balance = 0,
    this.point = 0,
    this.role = 'user',
    this.token,
    this.badgeID,
    this.badgeName,
    this.txCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      ID: json['user_id'],
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      balance: json['balance'] ?? 0,
      point: json['point'] ?? 0,
      role: json['role'] ?? 'user',
      badgeID: json['badge_id'],
      badgeName: json['badge_name'],
      txCount: json['tx_count'],
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': ID,
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'address': address,
      'balance': balance,
      'point': point,
      'role': role,
      'badgeID': badgeID,
      'badgeName': badgeName,
      'txCount': txCount,
    };
  }
}
