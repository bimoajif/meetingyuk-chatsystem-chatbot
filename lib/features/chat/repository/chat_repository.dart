import 'package:chatbot_meetingyuk/common/utils/utils.dart';
import 'package:chatbot_meetingyuk/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverId,
    required UserModel senderUser
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap = await firestore.collection('merchants').doc(recieverId).get();
    } catch(e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}