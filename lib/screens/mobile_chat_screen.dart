import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/chat_list.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/info.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          info[0]['name'].toString(),
          style: const TextStyle(fontSize: 18),
        ),
        leading: const CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/8/85/Elon_Musk_Royal_Society_%28crop1%29.jpg'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: ChatList()),
          TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.grey,
                      )),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.money,
                            color: Colors.grey,
                          )),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
