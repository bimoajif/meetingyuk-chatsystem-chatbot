import 'package:flutter/material.dart';

class ChatbotAppbar extends StatelessWidget {
  const ChatbotAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 40.0,
          width: 40.0,
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/chatbot-pp.png'),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  'MeetingYuk Chatbot',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0),
                ),
              ],
            ),
            const Text(
              'Personal Assistant',
              style: TextStyle(fontSize: 14.0, color: Colors.white30),
            ),
          ],
        )
      ],
    );
  }
}
