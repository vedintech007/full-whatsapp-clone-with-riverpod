import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repo.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_group.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String name,
    File groupPic,
    List<Contact> selectedContacts,
  ) async {
    try {
      List<String> uids = [];

      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContacts[i].phones[0].number.replaceAll(' ', ''),
            )
            .get();

        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          if (userCollection.docs[0].data()['uid'] != auth.currentUser!.uid) {
            uids.add(userCollection.docs[0].data()['uid']);
          }
        }
      }

      final userData = await firestore
          .collection("users")
          .where(
            "uid",
            isEqualTo: auth.currentUser!.uid,
          )
          .get();

      final userName = userData.docs[0].data()['name'];

      var groupId = const Uuid().v1();
      String profileUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            "groups/$groupId",
            groupPic,
          );

      final timeSent = DateTime.now();

      ChatGroup group = ChatGroup(
        senderId: auth.currentUser!.uid,
        name: name,
        groupId: groupId,
        lastMessage: "Group created by $userName",
        groupPic: profileUrl,
        membersUid: [auth.currentUser!.uid, ...uids],
        timeSent: timeSent,
      );

      await firestore
          .collection("groups")
          .doc(
            groupId,
          )
          .set(group.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
