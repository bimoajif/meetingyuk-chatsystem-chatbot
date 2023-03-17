import 'package:chatbot_meetingyuk/common/widgets/loader.dart';
import 'package:chatbot_meetingyuk/features/chat/controller/chat_controller.dart';
import 'package:chatbot_meetingyuk/features/chat/widgets/recipient_message_card.dart';
import 'package:chatbot_meetingyuk/features/chat/widgets/sender_message_card.dart';
import 'package:chatbot_meetingyuk/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


class ChatList extends ConsumerStatefulWidget {
  final String recieverId;
  const ChatList({Key? key, required this.recieverId}) : super(key: key);

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageController = ScrollController();

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: ref.read(chatControllerProvider).chatStream(widget.recieverId),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _messageController.jumpTo(_messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: _messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat('Hm').format(messageData.timeSent);
            if (messageData.senderId == FirebaseAuth.instance.currentUser!.uid) {
              return SenderMessageCard(
                message: messageData.text,
                time: timeSent,
                type: messageData.type,
              );
            }
            return RecipientMessageCard(
              message: messageData.text,
              time: timeSent,
              type: messageData.type,
            );
          },
        );
      }
    );
  }
}
