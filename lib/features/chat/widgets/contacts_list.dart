import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/commons/utils/utils.dart';
import 'package:whatsapp/commons/widgets/error.dart';
import 'package:whatsapp/commons/widgets/loader.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';
import 'package:whatsapp/info.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';
import 'package:whatsapp/models/chat_contact.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: StreamBuilder<List<ChatContact>>(
            stream: ref.watch(chatRepositoryProvider).getChatContact(),
            builder: (context,snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const Loader();
              }
              if (snapshot.data==null){
                return ErrorScreen(error:'Data is null');
              }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContactData=snapshot.data![index];
                  print('User Url is : ${chatContactData.profilePic}');
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>MobileChatScreen(name: chatContactData.name, uid: chatContactData.contactId)));
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
                                  NetworkImage(chatContactData.profilePic),

                            ),
                            title: Text(
                              chatContactData.name,
                              style: const TextStyle(fontSize: 18),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                chatContactData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            trailing: Text(
                              DateFormat.Hm().format(chatContactData.timeSent),
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
                });
          }
        ));
  }
}
