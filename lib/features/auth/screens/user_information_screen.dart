import 'dart:async';
import 'dart:io';
import 'package:chatbot_meetingyuk/common/widgets/splash_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:chatbot_meetingyuk/screen/home_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformationScreen({super.key});

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  File? image;

  void storeUserData() async {
    String name = 'John Doe';

    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  void initState() {
    super.initState();
    storeUserData();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeChat(),
          ),
          (route) => false,
        );
      },
    );
    return const SplashScreen(
      loading: true,
    );
  }
}
