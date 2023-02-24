import 'package:flutter/material.dart';
import 'sender_message_card.dart';
import 'recipient_message_card.dart';
import 'package:chatbot_meetingyuk/info.dart';

class ChatList extends StatelessWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        if (messages[index]['isMe'] == true) {
          return SenderMessageCard(
            message: messages[index]['text'].toString(),
            time: messages[index]['time'].toString(),
          );
        }
        return RecipientMessageCard(
          message: messages[index]['text'].toString(),
          time: messages[index]['time'].toString(),
        );
      },
    );
  }
}
