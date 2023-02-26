import 'dart:io';

import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:chatbot_meetingyuk/common/repository/common_firebase_storage_repository.dart';
import 'package:chatbot_meetingyuk/common/utils/utils.dart';
import 'package:chatbot_meetingyuk/models/chat_contact.dart';
import 'package:chatbot_meetingyuk/models/message.dart';
import 'package:chatbot_meetingyuk/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        contacts.add(
          ChatContact(
            name: user.name,
            profilePic: user.profilePic,
            contactId: user.uid,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String text,
    DateTime timeSent,
    String receiverId,
  ) async {
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(
          receiverChatContact.toMap(),
        );

    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .set(
          senderChatContact.toMap(),
        );
  }

  _saveMessageToMessageSubcollection({
    required String receiverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required receiverUsername,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      UserModel receiverUserData;

      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        text,
        timeSent,
        receiverId,
      );

      _saveMessageToMessageSubcollection(
        receiverId: receiverId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        receiverUsername: receiverUserData.name,
        messageType: MessageEnum.TEXT,
      );
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required ProviderRef ref,
    required String receiverId,
    required UserModel senderUserData,
    required MessageEnum messageEnum,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl =
          await ref.read(commonFirebaseStorageRepository).storeFileToFirebase(
                'chat/${messageEnum.type}/${senderUserData.uid}/$receiverId/$messageId',
                file,
              );

      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMessage;

      switch (messageEnum) {
        case MessageEnum.IMAGE:
          contactMessage = '📷 Photo';
          break;
        case MessageEnum.VIDEO:
          contactMessage = '📸 Video';
          break;
        case MessageEnum.AUDIO:
          contactMessage = '🎵 Audio';
          break;
        case MessageEnum.GIF:
          contactMessage = 'GIF';
          break;
        default:
          contactMessage = 'GIF';
      }
      
      _saveDataToContactsSubcollection(
        senderUserData,
        receiverUserData,
        contactMessage,
        timeSent,
        receiverId,
      );

      _saveMessageToMessageSubcollection(
        receiverId: receiverId,
        text: contactMessage,
        timeSent: timeSent,
        messageId: messageId,
        username: senderUserData.name,
        receiverUsername: receiverUserData.name,
        messageType: messageEnum,
      );
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
