// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  ),
);

class ChatRepository {
  ChatRepository(
    this.firestore, // 0593049933
    this.auth,
  );

  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  void _saveDataToContactsSubCollection(
    UserModel senderUserData,
    UserModel recieverUserData,
    String text,
    DateTime timeSent,
    String recieverUserId,
  ) async {
    // users -> reciever user id => chats -> current user id -> set data
    var recieverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      lastMessage: text,
      timeSent: timeSent,
    );

    await firestore.collection("users").doc(recieverUserId).collection("chats").doc(auth.currentUser!.uid).set(
          recieverChatContact.toMap(),
        );

    // users -> current user id => chats -> reciever user id -> set data
    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      lastMessage: text,
      timeSent: timeSent,
    );

    await firestore.collection("users").doc(auth.currentUser!.uid).collection("chats").doc(recieverUserId).set(
          senderChatContact.toMap(),
        );
  }

  void _saveMessageToMessageSubCollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String senderUserName,
    required String recieverUserName,
    required MessageEnum messageType,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
    );

    // user -> sender id -> reciever id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chat')
        .doc(recieverUserId)
        .collection('messages')
        .doc(
          messageId,
        )
        .set(
          message.toMap(),
        );

    // user -> reciever id -> sender id -> messages -> message id -> store message
    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chat')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(
          messageId,
        )
        .set(
          message.toMap(),
        );
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap = await firestore.collection("users").doc(recieverUserId).get();

      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
        senderUser,
        recieverUserData,
        text,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        senderUserName: senderUser.name,
        recieverUserName: recieverUserData.name,
        messageType: MessageEnum.text,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
