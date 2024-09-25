import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/my_message_card.dart';
import 'package:whatsapp/Widgets/sender_message_card.dart';
import 'package:whatsapp/info.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: messages.length, itemBuilder: (context, index) {
      if (messages[index]['isMe'] == true) {
        //MyMessageCard
       return MyMessageCard(message: messages[index]['text'].toString(),
          time: messages[index]['time'].toString(),);
      }
      //SenderMessageCard
      return SenderMessageCard(message: messages[index]['text'].toString(),
        time: messages[index]['time'].toString(),);
    });
  }
}
