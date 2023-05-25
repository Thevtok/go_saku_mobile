// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_saku/app/controller/photo_controller.dart';

import '../../core/network/api_user.dart';
import '../../core/utils/hive_service.dart';
import '../../domain/model/abstract/repository/userRepo.dart';
import '../../domain/model/abstract/usecase/userUsecase.dart';
import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/use_case/user_usecase.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final User user;

  const CustomAppBar({Key? key, required this.user}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(200);
}

class _CustomAppBarState extends State<CustomAppBar> {
  PhotoController pc = PhotoController();
  late Future<Uint8List?> _userPhoto;
  late ApiClient apiClient;
  late UserRepository userRepository;
  late UserUseCase userUsecase;
  @override
  void initState() {
    super.initState();
    apiClient = ApiClient();
    userRepository = UserRepositoryImpl(apiClient);
    userUsecase = UserUseCaseImpl(userRepository);
    _userPhoto = getTokenUserId().then((String? id) {
      if (id != null) {
        return userUsecase.getPhoto(id);
      } else {
        throw Exception('Username tidak tersedia');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 200,
      flexibleSpace: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/abstrak.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: FutureBuilder<Uint8List?>(
                    future: _userPhoto,
                    builder: (context, snapshot) {
                      final networkImage = snapshot.data;
                      if (snapshot.hasData) {
                        return Container(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: MemoryImage(networkImage!),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  right: -5,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      pc
                                          .postPhoto(widget.user.ID!, context)
                                          .then((response) {})
                                          .catchError((error) {});
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.data == null) {
                        return Container(
                          padding: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            height: 100,
                            width: 100,
                            child: Stack(
                              children: [
                                const ClipOval(
                                  child: CircleAvatar(
                                    radius: 50,
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  right: -5,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      pc
                                          .postPhoto(widget.user.ID!, context)
                                          .then((response) {})
                                          .catchError((error) {});
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const Text('data');
                    }),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.user.name,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    widget.user.phoneNumber,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
