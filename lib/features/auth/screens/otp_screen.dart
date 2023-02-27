import 'package:chatbot_meetingyuk/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {    
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('insert your OTP code'),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: "- - - - - -",
                    hintStyle: TextStyle(
                      fontSize: 30,
                    )),
                keyboardType: TextInputType.number,
                onChanged: (val) {
                  if(val.length == 6) {
                    print('verifying otp');
                    verifyOTP(ref, context, val.trim());
                  }
                  print('this function was run');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
