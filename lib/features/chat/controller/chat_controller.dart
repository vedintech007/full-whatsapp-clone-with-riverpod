// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/models/chat_contact.dart';
import 'package:whatsapp_clone/models/message.dart';

import '../repository/chat_repository.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(
    chatRepository: chatRepository,
    ref: ref,
  );
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Message>> chatStream(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
  }) {
    ref.read(userDataAuthProvider).whenData((authData) {
      chatRepository.sendTextMessage(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: authData!,
      );
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required MessageEnum messageEnum,
  }) {
    ref.read(userDataAuthProvider).whenData((authData) {
      chatRepository.sendFileMessage(
        context: context,
        file: file,
        recieverUserId: recieverUserId,
        senderUserData: authData!,
        messageEnum: messageEnum,
        ref: ref,
      );
    });
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
  }) {
    //https://giphy.com/gifs/party-celebrate-birthday-DFexVkRG7gX9oCy68r
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = "https://i.giphy.com/media/$gifUrlPart/200.gif";
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
            context: context,
            gifUrl: newGifUrl,
            recieverUserId: recieverUserId,
            senderUser: value!,
          ),
        );
    // ref.read(userDataAuthProvider).whenData((authData) {
    //   chatRepository.sendTextMessage(
    //     context: context,
    //     text: text,
    //     recieverUserId: recieverUserId,
    //     senderUser: authData!,
    //   );
    // });
  }
}
