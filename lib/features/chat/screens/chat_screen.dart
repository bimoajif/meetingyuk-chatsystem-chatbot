import 'package:chatbot_meetingyuk/common/widgets/loader.dart';
import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:chatbot_meetingyuk/features/chat/widgets/app_bar_content.dart';
import 'package:chatbot_meetingyuk/features/chat/widgets/text_input_field.dart';
import 'package:chatbot_meetingyuk/models/user_model.dart';
import 'package:chatbot_meetingyuk/features/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerWidget {
  static const String routeName = '/chat-screen';
  final String profilePic;
  final String name;
  final String uid;
  const ChatScreen(
      {super.key,
      required this.profilePic,
      required this.name,
      required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
            titleSpacing: -10.0,
            toolbarHeight: 78.0,
            backgroundColor: Colors.white,
            elevation: 1.0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: StreamBuilder<UserModel>(
              stream: ref.read(authControllerProvider).userDataById(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                final status = snapshot.data!.isOnline ? 'online' : 'offline';
                return AppBarContent(
                  profilePic: profilePic,
                  name: name,
                  status: status,
                  color: status == 'online' ? Colors.green : Colors.grey,
                );
              },
            )),
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/chat-background.png'),
                  fit: BoxFit.cover)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ChatList(
                  recieverId: uid,
                ),
              ),
              TextInputField(
                receiverId: uid,
              )
            ],
          ),
        ),
      ),
    );
  }
}
