import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:chatbot_meetingyuk/features/chat/widgets/display_message.dart';
import 'package:flutter/material.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum type;

  const SenderMessageCard({
    super.key,
    required this.message,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          clipBehavior: Clip.hardEdge,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          color: const Color(0xFF3880A4),
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Stack(
            children: [
              Padding(
                padding: type == MessageEnum.TEXT
                    ? const EdgeInsets.only(
                        left: 15,
                        right: 35,
                        top: 10,
                        bottom: 25,
                      )
                    : const EdgeInsets.only(
                        top: 0,
                        right: 0,
                        left: 0,
                        bottom: 0,
                      ),
                child: DisplayMessage(
                  message: message,
                  type: type,
                  isSender: true,
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
