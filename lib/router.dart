import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/widgets/error.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return _pageRoute(const LoginScreen());
    case OTPScreen.routeName:
      final verificationId = settings.arguments as String;
      return _pageRoute(OTPScreen(verificationId: verificationId));
    case UserInformationScreen.routeName:
      return _pageRoute(const UserInformationScreen());
    case SelectContactScreen.routeName:
      return _pageRoute(const SelectContactScreen());

    default:
      return _pageRoute(const ErrorScreen(error: "This page does not exist"));
  }
}

MaterialPageRoute<dynamic> _pageRoute(dynamic pageName) {
  return MaterialPageRoute(
    builder: (context) => pageName,
  );
}
