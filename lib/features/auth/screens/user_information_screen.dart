import 'package:flutter/material.dart';

class UserInformationScreen extends StatelessWidget {
  static const String routeName = "/user-information";
  const UserInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
    );
  }
}
