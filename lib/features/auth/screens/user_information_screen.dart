import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:chatbot_meetingyuk/common/utils/rsa_encryption.dart';
import 'package:chatbot_meetingyuk/common/widgets/splash_screen.dart';
import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:chatbot_meetingyuk/screen/home_chat.dart';
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
    String name = 'Alice';

    final e2ee = E2EE_RSA();
    final keyPair = e2ee.generateRSAKeyPair();

    String publicKey = extractKeyString(CryptoUtils.encodeRSAPublicKeyToPem(keyPair.publicKey as RSAPublicKey));
    String privateKey = extractKeyString(CryptoUtils.encodeRSAPrivateKeyToPem(keyPair.privateKey as RSAPrivateKey));

    if (name.isNotEmpty && publicKey.isNotEmpty) {
      ref.read(authControllerProvider).saveUserDataToFirebase(
            context,
            name,
            publicKey,
            image,
          );
    }

    ref.read(authControllerProvider).saveKeyPair(
          context,
          publicKey,
          privateKey,
        );
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
