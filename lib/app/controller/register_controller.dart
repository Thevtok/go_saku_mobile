// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_user.dart';
import '../../domain/model/abstract/usecase/userUsecase.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/screens/login_screen.dart';
import '../../domain/use_case/user_usecase.dart';
import '../circular_indicator/customCircular.dart';
import '../dialog/showDialog.dart';
import '../message/snackbar.dart';

final apiClient = ApiClient();
final userRepository = UserRepositoryImpl(apiClient);
final UserUseCase userUseCase = UserUseCaseImpl(userRepository);

class RegisterController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Future<void> register(BuildContext context) async {
    String name = nameController.text;
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phoneNumber = phoneController.text;
    String address = addressController.text;

    // Memeriksa apakah semua field telah terisi
    if (name.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty) {
      showSnackBar(context, 'All fields must be filled');
      return;
    }

    // Memeriksa format email
    if (!email.endsWith('@gmail.com')) {
      showSnackBar(
          context, 'Invalid email format. Email must end with @gmail.com');
      return;
    }

    // Memeriksa format password
    if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(password)) {
      showSnackBar(context,
          'Invalid password format. Password must have at least 1 uppercase letter, 1 number, and minimum 8 characters');
      return;
    }

    // Memeriksa format nomor telepon
    if (!RegExp(r'^\d{11,13}$').hasMatch(phoneNumber)) {
      showSnackBar(context,
          'Invalid phone number format. Phone number must consist of 11 to 13 digits');
      return;
    }

    User user = User(
      name: name,
      username: username,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      address: address,
      balance: 0,
      point: 0,
      role: 'user',
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CustomCircularProgressIndicator(
          message: 'Loading',
        );
      },
    );

    final result = await userUseCase.register(user);

    if (result != null) {
      showCustomDialog(
        context,
        'Success',
        'Account registered successfully',
        () {
          Get.off(const login_Screnn());
        },
      );
    } else {
      showSnackBar(context, 'Failed to register');
    }
  }
}
