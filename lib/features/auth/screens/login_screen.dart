import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_meetingyuk/common/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();

    @override
    void dispose() {
      super.dispose();
      phoneController.dispose();
    }

    void sendPhoneNumber() {
      String phoneNumber = phoneController.text.trim();
      ref.read(authControllerProvider).signInWithPhone(context, phoneNumber);
    }

    final size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/landing-background.png'),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Masukkan Nomor HP',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width * 0.75,
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(hintText: 'phone number'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: size.width * 0.75,
                child: CustomButton(
                  text: 'CONTINUE',
                  onpressed: sendPhoneNumber,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
