import 'dart:io';

import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:chatbot_meetingyuk/features/chat/repository/chat_repository.dart';
import 'package:chatbot_meetingyuk/models/chat_contact.dart';
import 'package:chatbot_meetingyuk/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContact();
  }

  Stream<List<Message>> chatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverId,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverId: receiverId,
            senderUser: value!,
          ),
        );
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverId,
    MessageEnum messageEnum,
  ) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverId: receiverId,
            senderUserData: value!,
            messageEnum: messageEnum,
            ref: ref,
          ),
        );
  }
}
