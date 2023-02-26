// import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayMessage({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          );
  //   return type == MessageEnum.TEXT
  //       ? Text(
  //           message,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             color: Colors.white,
  //           ),
  //         )
  //       : CachedNetworkImage(
  //           imageUrl: message,
  //         );
  }
}
