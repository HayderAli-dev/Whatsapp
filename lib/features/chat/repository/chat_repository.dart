import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/commons/enums/message_enum.dart';
import 'package:whatsapp/commons/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp/commons/utils/utils.dart';
import 'package:whatsapp/models/chat_contact.dart';
import 'package:whatsapp/models/message.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContact() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .map((event) {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        ChatContact chatContact = ChatContact.fromJson(document.data());
        contacts.add(chatContact);
      }
      print("Total contacts fetched: ${contacts.length}");
      return contacts;
    });
  }

  Stream<List<Message>> getMessages(String receiverUserID) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserID)
        .collection('messages')
        .orderBy('sentTime')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var doc in event.docs) {
        var message = Message.fromJson(doc.data());
        messages.add(message);
      }
      return messages;
    });
  }

  void sendTextMessage(
      {required BuildContext context,
      required String text,
      required String receiverUserID,
      required UserModel senderUserData}) async {
    try {
      var sentTime = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserID).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);

      _saveDataToContactSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: text,
          sentTime: sentTime,
          receiverUserID: receiverUserID);
      final messageID = Uuid().v1();
      _saveMessageToMessageSubColletion(
          receiverUserID: receiverUserID,
          text: text,
          messageID: messageID,
          senderUserName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          sentTime: sentTime,
          messageType: MessageEnum.text);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage(
      {required BuildContext context,
      required String receiverUserId,
      required UserModel senderUserData,
      required File file,
      required ProviderRef ref,
      required MessageEnum messageEnum}) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();
      var filePath='chat/${messageEnum.type}/${senderUserData.uid}/$receiverUserId/$messageId.png';
      String messageURL = await ref
          .read(commonFirebaseStorageReposioryProvider)
          .storeFileTFirebase(
              filePath,
              file);
      print('Message URL is $messageURL');
      UserModel receiverUserData;
      var userDataMap =
          await firestore.collection('users').doc(receiverUserId).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      var contactMsg;
      switch (messageEnum) {
        case MessageEnum.text:
          contactMsg = ' ';
          break;
        case MessageEnum.image:
          contactMsg = '📷 Photo';
          break;
        case MessageEnum.audio:
          contactMsg = '🎵 Audio';
          break;
        case MessageEnum.video:
          contactMsg = '🎥 Video';
          break;
        case MessageEnum.gif:
          contactMsg = 'GIF';
          break;
      }
      _saveDataToContactSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: contactMsg,
          sentTime: timeSent,
          receiverUserID: receiverUserId);

      _saveMessageToMessageSubColletion(
          receiverUserID: receiverUserId,
          text: messageURL,
          messageID: messageId,
          senderUserName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          sentTime: timeSent,
          messageType: messageEnum);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
      print(e.toString());
    }
  }

  void sendGIFMessage(
      {required BuildContext context,
        required String gifURL,
        required String receiverUserID,
        required UserModel senderUserData}) async {
    try {
      var sentTime = DateTime.now();
      UserModel receiverUserData;
      var userDataMap =
      await firestore.collection('users').doc(receiverUserID).get();
      receiverUserData = UserModel.fromJson(userDataMap.data()!);
      _saveDataToContactSubCollection(
          senderUserData: senderUserData,
          receiverUserData: receiverUserData,
          text: 'GIF',
          sentTime: sentTime,
          receiverUserID: receiverUserID);
      final messageID = Uuid().v1();
      _saveMessageToMessageSubColletion(
          receiverUserID: receiverUserID,
          text: gifURL,
          messageID: messageID,
          senderUserName: senderUserData.name,
          receiverUserName: receiverUserData.name,
          sentTime: sentTime,
          messageType: MessageEnum.gif);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void _saveDataToContactSubCollection(
      {required UserModel senderUserData,
      required UserModel receiverUserData,
      required String text,
      required DateTime sentTime,
      required String receiverUserID}) async {
    final receiverChatContact = ChatContact(
        name: senderUserData.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: sentTime,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(receiverUserID)
        .collection('chats')
        .doc(senderUserData.uid)
        .set(receiverChatContact.toJson());

    final senderChatContact = ChatContact(
        name: receiverUserData.name,
        profilePic: receiverUserData.profilePic,
        contactId: receiverUserData.uid,
        timeSent: sentTime,
        lastMessage: text);
    await firestore
        .collection('users')
        .doc(senderUserData.uid)
        .collection('chats')
        .doc(receiverUserID)
        .set(senderChatContact.toJson());
  }

  void _saveMessageToMessageSubColletion(
      {required String receiverUserID,
      required String text,
      required String messageID,
      required String senderUserName,
      required String receiverUserName,
      required DateTime sentTime,
      required MessageEnum messageType}) async {
    final message = Message(
        senderId: auth.currentUser!.uid,
        receiverId: receiverUserID,
        text: text,
        sentTime: sentTime,
        type: messageType,
        messageId: messageID,
        isSeen: false);
//Storing messages in Senders Database
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserID)
        .collection('messages')
        .doc(messageID)
        .set(message.toJson());

    //Storing messages in receivers Database
    await firestore
        .collection('users')
        .doc(receiverUserID)
        .collection('chats')
        .doc(auth.currentUser!.uid)
        .collection('messages')
        .doc(messageID)
        .set(message.toJson());
  }
}
