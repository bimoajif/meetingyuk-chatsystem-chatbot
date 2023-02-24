import 'package:chatbot_meetingyuk/colors.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({super.key});

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  bool isShowSendButton = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
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
        constraints: const BoxConstraints.expand(height: 90),
        contentPadding: const EdgeInsets.only(top: 35, left: 24),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: SizedBox(
          width: 73,
          height: 90,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file),
            // color: primaryColor,
          ),
        ),
        hintText: 'Tulis Pesan Anda...',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14
        ),
        suffixIcon: Container(
          height: 70,
          width: 70,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(40)),
            color: primaryColor
          ),
          child: IconButton(
            onPressed: () {},
            // padding: const EdgeInsets.all(24.0),
            color: Colors.white,
            iconSize: 30,
            icon: Icon(
              isShowSendButton ? Icons.send : Icons.mic,
            ),
          ),
        )
      ),
    );
  }
}