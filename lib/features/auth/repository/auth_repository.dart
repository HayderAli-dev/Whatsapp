import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/commons/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp/commons/utils/utils.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/screens/mobile_screen_layout.dart';

//authRepository Provider
final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    if (userData.data() != null) {
      print('User data is $userData');
      user = UserModel.fromJson(userData.data()!);
    }
    return user;
  }

  void signInWithPhoneNumber(BuildContext context, String phoneNumber) async {
    try {
      showSnackBar(
          context: context, content: 'Function Called with $phoneNumber');
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credentials) async {
            await auth.signInWithCredential(credentials);
          },
          verificationFailed: (FirebaseAuthException e) {
            showSnackBar(
                context: context,
                content: 'Verification failed: ${e.code} - ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            showSnackBar(
                context: context, content: 'Code sent $verificationId');
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);

      print('Signed In');
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required BuildContext context,
      required ProviderRef ref}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoURL = 'https://i.imgur.com/OkmTXOh.png';
      if (profilePic != null) {
        photoURL = await ref
            .read(CommonFirebaseStorageReposioryProvider)
            .storeFileTFirebase('profilePic/$uid', profilePic);
      }

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoURL,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);

      await firestore.collection('users').doc(uid).set(user.toJson());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString() + 'save User Data');
    }
  }
}
