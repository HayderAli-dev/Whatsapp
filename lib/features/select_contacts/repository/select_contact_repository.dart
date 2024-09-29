import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/commons/utils/utils.dart';
import 'package:whatsapp/models/user_model.dart';
import 'package:whatsapp/features/chat/screens/mobile_chat_screen.dart';

final selectContactRepositoryProvider = Provider((ref) {
  final firestore = FirebaseFirestore.instance;
  return SelectContactRepository(firestore: firestore);
});

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
            withProperties: true, withAccounts: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return contacts;
  }

  void selectContact(
      {required Contact selectedContact, required BuildContext context}) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromJson(document.data());
        String selectedPhoneNumber =
            selectedContact.phones[0].number.replaceAll(' ', '');
        if (selectedPhoneNumber.startsWith('0')) {
          selectedPhoneNumber = selectedPhoneNumber.replaceFirst('0', '92');
        }
        String onlinePhoneNumber =
            userData.phoneNumber.replaceAll(RegExp(r'\D'), '');
        print('selected: $selectedPhoneNumber');
        print('online: $onlinePhoneNumber');
        if (selectedPhoneNumber == onlinePhoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': userData.name, 'uid': userData.uid});
        }
      }
      if (!isFound) {
        showSnackBar(
            context: context,
            content: 'This phone number is not registered on whatsapp');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
