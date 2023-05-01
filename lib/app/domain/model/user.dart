abstract class UserRepository {
  Future<User?> login(String email, String password);
  Future<List<User>> getAll();
  Future<User?> getById(int id);
  Future<String> create(User user);
  Future<String> update(User user);
  Future<String> delete(int id);
}

abstract class UserUseCase {
  Future<User?> login(String email, String password);
  Future<List<User>?> findUsers();
  Future<User?> findById(int id);
  Future<String?> register(User user);
  Future<String?> edit(User user);
  Future<String?> unreg(int id);
}

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
      name: json['name'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      balance: json['balance'],
      point: json['point'],
      role: json['role'],
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
