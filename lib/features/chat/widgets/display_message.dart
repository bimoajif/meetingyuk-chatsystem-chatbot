import 'package:chatbot_meetingyuk/colors.dart';
import 'package:chatbot_meetingyuk/common/enums/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DisplayMessage extends StatelessWidget {
  final String message;
  final MessageEnum type;
  final bool isSender;
  const DisplayMessage({
    super.key,
    required this.message,
    required this.type,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.TEXT
        ? Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isSender == true ? Colors.white : Colors.black,
            ),
          )
        : FutureBuilder(
            future: Dio().get(message,
                options: Options(responseType: ResponseType.bytes)),
            builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.hasData) {
                return Image.memory(
                  snapshot.data!.data,
                  scale: 0.5,
                );
              } else if (snapshot.hasError) {
                return const Text(
                  'Error loading image',
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(
                    color: isSender == true ? Colors.white : primaryColor,
                  ),
                );
              }
            },
          );
  }
}
