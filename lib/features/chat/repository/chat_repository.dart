import 'dart:io';
import 'package:basic_utils/basic_utils.dart';
import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:chatbot_meetingyuk/common/repository/common_firebase_storage_repository.dart';
import 'package:chatbot_meetingyuk/common/utils/rsa_encryption.dart';
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
    final e2ee = E2EE_RSA();
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      final keyPair = await firestore
          .collection('keypair')
          .doc(auth.currentUser!.uid)
          .get();
      final strPrivateKey = keyPair.data()?['privateKey'] as String;
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);
        if (chatContact.lastMessage == '📷 Photo' || chatContact.lastMessage == '📸 Video' || chatContact.lastMessage == '🎵 Audio' || chatContact.lastMessage == 'GIF') {
          contacts.add(
            ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              contactId: user.uid,
              timeSent: chatContact.timeSent,
              lastMessage: chatContact.lastMessage,
            ),
          );
        } else {
          var decryptedText = e2ee.decrypter(
              CryptoUtils.rsaPrivateKeyFromPem(
                  addHeaderFooter(strPrivateKey, false)),
              chatContact.lastMessage);
          contacts.add(
            ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              contactId: user.uid,
              timeSent: chatContact.timeSent,
              lastMessage: decryptedText,
            ),
          );
        }
      }
      return contacts;
    });
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    final e2ee = E2EE_RSA();
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .asyncMap((event) async {
      final keyPair = await firestore
          .collection('keypair')
          .doc(auth.currentUser!.uid)
          .get();
      final strPrivateKey = keyPair.data()?['privateKey'] as String;
      List<Message> messages = [];
      for (var document in event.docs) {
        final message = Message.fromMap(document.data());
        if (message.type != MessageEnum.TEXT) {
          messages.add(Message(
            senderId: message.senderId,
            receiverId: message.receiverId,
            text: message.text,
            type: message.type,
            timeSent: message.timeSent,
            messageId: message.messageId,
            isSeen: message.isSeen,
          ));
        } else {
          var decryptedText = e2ee.decrypter(
              CryptoUtils.rsaPrivateKeyFromPem(
                  addHeaderFooter(strPrivateKey, false)),
              message.text);
          messages.add(Message(
            senderId: message.senderId,
            receiverId: message.receiverId,
            text: decryptedText,
            type: message.type,
            timeSent: message.timeSent,
            messageId: message.messageId,
            isSeen: message.isSeen,
          ));
        }
      }
      return messages;
    });
  }

  void _saveDataToContactsSubcollection(
    UserModel senderUserData,
    UserModel receiverUserData,
    String senderText,
    String receiverText,
    DateTime timeSent,
    String receiverId,
  ) async {
    var receiverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timeSent,
      lastMessage: receiverText,
    );

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .set(receiverChatContact.toMap());

    var senderChatContact = ChatContact(
      name: receiverUserData.name,
      profilePic: receiverUserData.profilePic,
      contactId: receiverUserData.uid,
      timeSent: timeSent,
      lastMessage: senderText,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .set(senderChatContact.toMap());
  }

  _saveMessageToMessageSubcollection({
    required String receiverId,
    required String senderText,
    required String receiverText,
    required DateTime timeSent,
    required String messageId,
    required String username,
    required receiverUsername,
    required MessageEnum messageType,
  }) async {
    final senderMessage = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      text: senderText,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );
    final receiverMessage = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      text: receiverText,
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
        .set(senderMessage.toMap());

    await firestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(receiverMessage.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel senderUser,
  }) async {
    try {
      final e2ee = E2EE_RSA();
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      UserModel senderUserData;
      UserModel receiverUserData;

      var senderDataMap =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();
      var userDataMap =
          await firestore.collection('users').doc(receiverId).get();
      senderUserData = UserModel.fromMap(senderDataMap.data()!);
      receiverUserData = UserModel.fromMap(userDataMap.data()!);

      final senderPublicKey = CryptoUtils.rsaPublicKeyFromPem(
        addHeaderFooter(
          senderUserData.publicKey,
          true,
        ),
      );
      final receiverPublicKey = CryptoUtils.rsaPublicKeyFromPem(
        addHeaderFooter(
          receiverUserData.publicKey,
          true,
        ),
      );

      String senderText = e2ee.encrypter(senderPublicKey, text);
      String receiverText = e2ee.encrypter(receiverPublicKey, text);

      _saveDataToContactsSubcollection(
        senderUser,
        receiverUserData,
        senderText,
        receiverText,
        timeSent,
        receiverId,
      );

      _saveMessageToMessageSubcollection(
        receiverId: receiverId,
        senderText: senderText,
        receiverText: receiverText,
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

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
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
        contactMessage,
        timeSent,
        receiverId,
      );

      _saveMessageToMessageSubcollection(
        receiverId: receiverId,
        senderText: imageUrl,
        receiverText: imageUrl,
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
