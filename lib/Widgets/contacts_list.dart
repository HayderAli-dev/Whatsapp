import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/screens/mobile_chat_screen.dart';

class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: info.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MobileChatScreen()));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              NetworkImage(info[index]['profilePic']!),
                        ),
                        title: Text(
                          info[index]['name'].toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            info[index]['message'].toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        trailing: Text(
                          info[index]['time'].toString(),
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                    ),
                    const Divider(
                      color: dividerColor,
                      indent: 40,
                      endIndent: 40,
                    )
                  ],
                ),
              );
            }));
  }
}
