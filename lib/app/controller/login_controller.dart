// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/network/api_user.dart';
import '../../domain/model/abstract/usecase/userUsecase.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/screens/homepage.dart';
import '../../domain/use_case/user_usecase.dart';
import '../circular_indicator/customCircular.dart';
import '../dialog/showDialog.dart';
import '../message/snackbar.dart';

final apiClient = ApiClient();
final userRepository = UserRepositoryImpl(apiClient);
final UserUseCase userUseCase = UserUseCaseImpl(userRepository);

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CustomCircularProgressIndicator(
          message: 'Loading',
        );
      },
    );

    final result = await userUseCase.login(email, password);

    Navigator.pop(context); // Menutup dialog setelah login selesai

    if (result != null) {
      // Login berhasil
      showCustomDialog(
        context,
        'Success',
        'Redirecting to home page',
        () {
          Get.off(const HomePage());
        },
      );
    } else {
      // Login gagal
      showSnackBar(context, 'Invalid email or password');
    }
  }
}
