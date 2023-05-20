import 'package:chatbot_meetingyuk/common/widgets/error_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/screens/login_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/screens/otp_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/screens/user_information_screen.dart';
import 'package:chatbot_meetingyuk/features/select_user/screens/select_user_screen.dart';
import 'package:chatbot_meetingyuk/features/chat/screens/chat_screen.dart';
import 'package:chatbot_meetingyuk/screen/home_chat.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(verificationId: verificationId),
      );
    case UserInformationScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const UserInformationScreen(),
      );
    case HomeChat.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomeChat(),
      );
    case SelectUserScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const SelectUserScreen(),
      );
    case ChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final profilePic = arguments['profilePic'];
      final name = arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(
        builder: (context) => ChatScreen(
          profilePic: profilePic,
          name: name,
          uid: uid,
        ),
      );
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "this page doesn't exist!"),
              ));
  }
}
