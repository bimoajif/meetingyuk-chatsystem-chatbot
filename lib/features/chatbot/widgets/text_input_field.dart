import 'dart:io';
import 'package:chatbot_meetingyuk/colors.dart';
import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:chatbot_meetingyuk/common/utils/utils.dart';
import 'package:chatbot_meetingyuk/features/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TextInputField extends ConsumerStatefulWidget {
  final String receiverId;

  const TextInputField({super.key, required this.receiverId});

  @override
  ConsumerState<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends ConsumerState<TextInputField> {
  bool isShowSendButton = false;

  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _messageController,
      onChanged: (val) {
        if (val.isNotEmpty) {
          setState(() {
            isShowSendButton = true;
          });
        } else {
          setState(() {
            isShowSendButton = false;
          });
        }
      },
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        border: InputBorder.none,
        // constraints: const BoxConstraints.expand(height: 90),
        contentPadding: const EdgeInsets.only(
          top: 25,
          left: 24,
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Padding(
          padding: EdgeInsets.only(
            top: 0.0,
            left: 10.0,
          ),
        ),
        hintText: 'Tulis Pesan Anda...',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        suffixIcon: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(0),
            ),
            color: primaryColor,
          ),
          child: GestureDetector(
            onTap: sendTextMessage,
            child: Icon(
              isShowSendButton ? Icons.send : Icons.mic,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
