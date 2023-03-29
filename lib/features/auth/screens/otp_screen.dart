import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/widgets/size_config.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = "/otp-screen";
  const OTPScreen({super.key, required this.verificationId});

  final String verificationId;

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(context, verificationId, userOTP);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Verify your number"),
      ),
      body: Center(
        child: Column(
          children: [
            heightSpace(20),
            const Text("We have sent an SMS with a code"),
            SizedBox(
              width: size(context).width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    print("verifying otp...");
                    verifyOTP(ref, context, value.trim());
                  }

                  print("done verifying otp $value");
                },
                decoration: const InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
