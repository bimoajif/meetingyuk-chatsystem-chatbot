import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onpressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50)
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          letterSpacing: 5
        ),
      ),
    );
  }
}