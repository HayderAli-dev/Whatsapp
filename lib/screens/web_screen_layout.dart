import 'package:flutter/material.dart';
import 'package:whatsapp/Widgets/chat_list.dart';
import 'package:whatsapp/Widgets/contacts_list.dart';
import 'package:whatsapp/Widgets/web_chat_app_bar.dart';
import 'package:whatsapp/Widgets/web_profile_bar.dart';
import 'package:whatsapp/Widgets/web_search_bar.dart';
import 'package:whatsapp/colors.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        //For Home Screen Left Half
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Web Profile bar
                WebProfileBar(),
                //Web Search bar
                WebSearchBar(),
                ContactsList()
              ],
            ),
          ),
        ),

        //For Chat Screen Right Half
        Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/backgroundImage.png'))),
            child: Column(
              children: [
                const WebChatAppBar(),
                const Expanded(child: ChatList()),
                Container(
                  height: MediaQuery.of(context).size.height * 0.073,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: dividerColor)),
                    color: chatBarMessage,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          )),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            fillColor: searchBarColor,
                            filled: true,
                            hintText: "Type Message",
                            suffixIcon: IconButton(
                                onPressed: () {}, icon: const Icon(Icons.mic)),
                            contentPadding: const EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: const BorderSide(
                                    width: 0, style: BorderStyle.none)),
                          ),
                          cursorColor: tabColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ))
      ],
    ));
  }
}
