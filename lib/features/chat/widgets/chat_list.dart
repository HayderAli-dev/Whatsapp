import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/Widgets/my_message_card.dart';
import 'package:whatsapp/Widgets/sender_message_card.dart';
import 'package:whatsapp/commons/widgets/error.dart';
import 'package:whatsapp/commons/widgets/loader.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/models/message.dart';

class ChatList extends ConsumerWidget {
  final String receiverUserId;
  final messageController=ScrollController();

  ChatList({super.key, required this.receiverUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Message>>(
        stream: ref.read(chatControllerProvider).getMessages(receiverUserId),
        builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Loader();
          }
          if(!snapshot.hasData && snapshot.data!.isEmpty){
            return const ErrorScreen(error: 'No Available Messages');
          }

          WidgetsBinding.instance.addPostFrameCallback((_){
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              messageController.jumpTo(messageController.position.maxScrollExtent);
            }

          });
          return ListView.builder(
            controller: messageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var message=snapshot.data![index];
                var timeSent=DateFormat.Hm().format(message.sentTime);
                if (message.senderId==FirebaseAuth.instance.currentUser!.uid) {
                  //MyMessageCard
                  return MyMessageCard(
                    message: message.text,
                    time: DateFormat.Hm().format(message.sentTime),
                  );
                }
                //SenderMessageCard
                return SenderMessageCard(
                  message: message.text,
                  time:DateFormat.Hm().format(message.sentTime),
                );
              });
        });
  }
}
