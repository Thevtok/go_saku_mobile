class User {
  final String name;
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final String address;
  int balance;
  int point;
  String role;

  User(
      {required this.name,
      required this.username,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.address,
      this.balance = 0,
      this.point = 0,
      this.role = 'user'});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      address: json['address'] ?? '',
      balance: json['balance'] ?? 0,
      point: json['point'] ?? 0,
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'address': address,
    };
  }
}

class UserResponse {
  String name;
  String username;
  String email;
  String phoneNumber;
  String address;
  int balance;
  int point;

  UserResponse({
    required this.name,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.balance,
    required this.point,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      name: json['name'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      balance: json['balance'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'balance': balance,
      'point': point,
    };
  }
}
