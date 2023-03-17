import 'package:chatbot_meetingyuk/colors.dart';
import 'package:chatbot_meetingyuk/features/chatbot/widgets/chat_list.dart';
import 'package:chatbot_meetingyuk/features/chatbot/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_meetingyuk/features/chatbot/widgets/chatbot_appbar.dart';

class ChatbotScreen extends StatelessWidget {
  static const String routeName = '/chatbot-screen';
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: -10.0,
          toolbarHeight: 78.0,
          backgroundColor: primaryColor,
          elevation: 1.0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const ChatbotAppbar(),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/chat-background.png'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                child: ChatList(
                  recieverId: '0',
                ),
              ),
              TextInputField(
                receiverId: '0',
              )
            ],
          ),
        ),
      ),
    );
  }
}
