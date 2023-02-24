import 'package:flutter/material.dart';
import 'package:chatbot_meetingyuk/colors.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RecipientMessageCard extends StatelessWidget {
  final String message;
  final String time;

  const RecipientMessageCard({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15)
            )),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 10,
                  bottom: 25,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 15,
                child: Row(
                  children: [
                    Text(
                      time,
                      style:const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
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