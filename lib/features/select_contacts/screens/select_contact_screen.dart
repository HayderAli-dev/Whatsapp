import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/commons/widgets/error.dart';
import 'package:whatsapp/commons/widgets/loader.dart';
import 'package:whatsapp/features/select_contacts/controller/select_contact_controller.dart';

class SelectContactScreen extends ConsumerWidget {
  const SelectContactScreen({super.key});
  static const routeName = '/select-contact';

  void selectContact(
      WidgetRef ref, BuildContext context, Contact selectedContact) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact: selectedContact, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Contacts'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: ref.watch(getContactProvider).when(data: (contactList) {
          return ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (context, index) {
                final contact = contactList[index];
                print('Contacts aa gai${contact.displayName}');
                return InkWell(
                  onTap: () {
                    selectContact(ref, context, contact);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(fontSize: 18),
                      ),
                      leading: contact.photo == null
                          ? null
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                    ),
                  ),
                );
              });
        }, error: (error, trace) {
          return ErrorScreen(error: error.toString() + 'error aa gya contact');
        }, loading: () {
          return const Loader();
        }));
  }
}
