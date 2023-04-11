import 'package:flutter/material.dart';
import 'package:whatsapp_clone/colors.dart';
import 'package:whatsapp_clone/common/widgets/custom_button.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/widgets/size_config.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void naviagteToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              heightSpace(50),
              const Text(
                "Welcome to Whatsapp",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              mediaHeightSpace(context, 9),
              Image.asset(
                "assets/bg.png",
                height: 340,
                width: 340,
                color: tabColor,
              ),
              mediaHeightSpace(context, 9),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Read our privacy policy. Tap "Agree and continue" to accept the Terms of Service',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: greyColor,
                    // fontSize: 14,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              heightSpace(10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: CustomButton(
                  text: "AGREE AND CONTINUE",
                  onPressed: () => naviagteToLoginScreen(context),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
