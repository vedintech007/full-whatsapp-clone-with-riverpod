// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/constants/string_validator.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider(
  (ref) => SelectContactRepository(
    firestore: FirebaseFirestore.instance,
  ),
);

class SelectContactRepository {
  SelectContactRepository({required this.firestore});
  final FirebaseFirestore firestore;

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection("users").get();

      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        String selectPhoneNum = await convertPhoneNumber(selectedContact.phones[0].number);

        print("yeah starts with 0 and now is $selectPhoneNum");

        if (selectPhoneNum == userData.phoneNumber) {
          isFound = true;
          // if (context.mounted) {
          Navigator.pushNamed(
            context,
            MobileChatScreen.routeName,
            arguments: {
              "name": userData.name,
              "uid": userData.uid,
            },
          );
          // }
        }
      }

      if (!isFound) {
        showSnackBar(context: context, content: "This number is not registered on our platform");
      }
    } catch (e) {
      print("Picking contact error is $e");
    }
  }
}
