import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/commons/enums/message_enum.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/message.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(BuildContext context, String text,
      String receiverUserID) {
    ref.read(userDataAuthProvider).whenData((senderUserData) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverUserID: receiverUserID,
            senderUserData: senderUserData!));
  }

  void sendFileMessage(BuildContext context, File file, String receiverUserID,
      MessageEnum messageEnum) {
    ref.read(userDataAuthProvider).whenData((senderUserData) =>
        chatRepository.sendFileMessage(
            context: context,
            file: file,
            receiverUserId: receiverUserID,
            senderUserData: senderUserData!,
            ref: ref,
            messageEnum: messageEnum));
  }


  Stream<List<ChatContact>> chatContact() {
    return chatRepository.getChatContact();
  }

  Stream<List<Message>> getMessages(String receiverUserID) {
    return chatRepository.getMessages(receiverUserID);
  }
}