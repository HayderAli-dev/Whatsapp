import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  // Convert a ChatContact object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastMessage': lastMessage,
    };
  }

  // Create a ChatContact object from a JSON map
  factory ChatContact.fromJson(Map<String, dynamic> json) {
    return ChatContact(
      name: json['name'],
      profilePic: json['profilePic'],
      contactId: json['contactId'],
      timeSent: (json['timeSent'] as Timestamp).toDate(),
      lastMessage: json['lastMessage'],
    );
  }
}
