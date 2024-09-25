import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/repository/auth_repository.dart';
import 'package:whatsapp/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final AuthRepository authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

//Future provider
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});
  void signInWithPhoneNumber(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhoneNumber(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationid, String userOTP) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationid, userOTP: userOTP);
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required BuildContext context}) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, context: context, ref: ref);
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }
}
