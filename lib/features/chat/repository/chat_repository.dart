import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/repository/common_firebase_storage_repo.dart';
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

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection("users")
        .doc(auth.currentUser!.uid)
        .collection(
          "chats",
        )
        .orderBy("timeSent", descending: true)
        .snapshots()
        .asyncMap(
      (collection) async {
        List<ChatContact> contacts = [];

        for (var document in collection.docs) {
          var chatContact = ChatContact.fromMap(document.data());
          var userData = await firestore.collection("users").doc(chatContact.contactId).get();

          var user = UserModel.fromMap(userData.data()!);

          contacts.add(
            ChatContact(
              name: user.name,
              profilePic: user.profilePic,
              contactId: chatContact.contactId,
              lastMessage: chatContact.lastMessage,
              timeSent: chatContact.timeSent,
            ),
          );
        }

        return contacts;
      },
    );
  }

  Stream<List<Message>> getChatStream(String recieverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chat')
        .doc(
          recieverUserId,
        )
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<Message> messages = [];

      for (var document in event.docs) {
        messages.add(Message.fromMap(document.data()));
      }
      return messages;
    });
  }

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
    required MessageReply? messageReply,
    required MessageEnum repliedMessageType,
    // required String senderUserName,
    // required String recieverUserName,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      recieverId: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? "" : messageReply.message,
      repliedTo: messageReply == null
          ? ""
          : messageReply.isMe
              ? senderUserName
              : recieverUserName,
      repliedMessageType: repliedMessageType,
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
    required MessageReply? messageReply,
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
        messageReply: messageReply,
        repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref.read(commonFirebaseStorageRepositoryProvider).storeFileToFirebase(
            "chat/${messageEnum.type}/${senderUserData.uid}/$recieverUserId/$messageId",
            file,
          );

      UserModel recieverUserData;
      var userDataMap = await firestore.collection('users').doc(recieverUserId).get();

      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      String contactMsg;

      switch (messageEnum) {
        case MessageEnum.image:
          contactMsg = "📸 Photo";
          break;
        case MessageEnum.video:
          contactMsg = "🎥 Video";
          break;
        case MessageEnum.audio:
          contactMsg = "🎶 Audio";
          break;
        case MessageEnum.gif:
          contactMsg = "Gif";
          break;
        default:
          contactMsg = "GIF";
      }

      _saveDataToContactsSubCollection(
        senderUserData,
        recieverUserData,
        contactMsg,
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: imageUrl,
        timeSent: timeSent,
        messageId: messageId,
        senderUserName: senderUserData.name,
        recieverUserName: recieverUserData.name,
        messageType: messageEnum,
        messageReply: messageReply,
        repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
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
        "🎁 GIF",
        timeSent,
        recieverUserId,
      );

      _saveMessageToMessageSubCollection(
        recieverUserId: recieverUserId,
        text: gifUrl,
        timeSent: timeSent,
        messageId: messageId,
        senderUserName: senderUser.name,
        recieverUserName: recieverUserData.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
        repliedMessageType: messageReply == null ? MessageEnum.text : messageReply.messageEnum,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen(
    BuildContext context,
    String recieverUserId,
    String messageId,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chat')
          .doc(recieverUserId)
          .collection('messages')
          .doc(
            messageId,
          )
          .update(
        {
          'isSeen': true,
        },
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
          .update(
        {
          'isSeen': true,
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
