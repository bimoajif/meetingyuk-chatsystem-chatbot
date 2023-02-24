import 'dart:io';

import 'package:chatbot_meetingyuk/common/utils/utils.dart';
import 'package:chatbot_meetingyuk/features/auth/screens/otp_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/screens/user_information_screen.dart';
import 'package:chatbot_meetingyuk/models/user_model.dart';
import 'package:chatbot_meetingyuk/screen/home_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData = await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if(userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackbar(context: context, content: e.message!);
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
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackbar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          '/Users/bimoajif/Documents/Kuliah/Skripsi/chatbot_meetingyuk/assets/images/placeholder-image-account.png';

      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!
      );

      await firestore.collection('users').doc(uid).set(user.toMap());
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  // Stream<UserModel> AllUserData() {
  //   return firestore.collection('users').doc().snapshots().map((event) => UserModel.fromMap(event.data()!),);
  // }

  Stream<UserModel> UserData(String userId) {
    return firestore.collection('merchants').doc(userId).snapshots().map((event) => UserModel.fromMap(event.data()!));
  }
}
