import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_clone/features/auth/screens/login_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/otp_screen.dart';
import 'package:whatsapp_clone/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp_clone/features/group/screens/create_group_screen.dart';
import 'package:whatsapp_clone/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status.dart';
import 'package:whatsapp_clone/features/status/screens/status_view_screen.dart';
import 'package:whatsapp_clone/models/status_model.dart';
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

    case MobileChatScreen.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      return _pageRoute(MobileChatScreen(
        name: name,
        uid: uid,
        isGroupChat: isGroupChat,
      ));
    case ConfirmStatusScreen.routeName:
      final file = settings.arguments as File;
      return _pageRoute(ConfirmStatusScreen(file: file));

    case StatusScreen.routeName:
      final status = settings.arguments as Status;
      return _pageRoute(StatusScreen(status: status));

    case CreateGroupScreen.routeName:
      return _pageRoute(const CreateGroupScreen());

    default:
      return _pageRoute(const ErrorScreen(error: "This page does not exist"));
  }
}

MaterialPageRoute<dynamic> _pageRoute(dynamic pageName) {
  return MaterialPageRoute(
    builder: (context) => pageName,
  );
}
