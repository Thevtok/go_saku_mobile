// ignore_for_file: deprecated_member_use, use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_saku/domain/screens/homepage.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/network/api_user.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/use_case/user_usecase.dart';
import '../circular_indicator/customCircular.dart';
import '../dialog/showDialog.dart';
import '../message/snackbar.dart';

final apiClient = ApiClient();

final userRepo = UserRepositoryImpl(apiClient);
final userUsecase = UserUseCaseImpl(userRepo);

class PhotoController {
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return File(pickedFile.path);
    }

    return null;
  }

  Future<String> postPhoto(String id, BuildContext context) async {
    final file = await pickImage();
    if (file != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const CustomCircularProgressIndicator(
            message: 'Loading',
          );
        },
      );
      try {
        final response = await userUsecase.postWithFormData(id, file);
        // Tampilkan dialog berhasil
        showCustomDialog(
          context,
          'Success',
          'Photo uploaded successfully',
          () {
            Navigator.of(context).pop(); // Tutup dialog
            Get.off(const HomePage()); // Pindah ke halaman beranda
          },
        );
        return response;
      } catch (e) {
        // Tampilkan snackbar gagal
        showSnackBar(context, 'Failed to upload photo');
        return '';
      }
    } else {
      throw Exception('No image selected');
    }
  }
}
