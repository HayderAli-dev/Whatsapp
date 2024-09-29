import 'package:whatsapp/commons/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime sentTime;
  final MessageEnum type;
  final String messageId;
  final bool isSeen;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.sentTime,
    required this.type,
    required this.messageId,
    required this.isSeen,
  });

  // Convert a Message object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'sentTime': sentTime.toIso8601String(), // Convert DateTime to String
      'type': type.toString().split('.').last, // Convert enum to String
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  // Create a Message object from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      sentTime:
          DateTime.parse(json['sentTime']), // Convert String back to DateTime
      type: MessageEnum.values.firstWhere((e) =>
          e.toString() ==
          'MessageEnum.${json['type']}'), // Convert String back to enum
      messageId: json['messageId'],
      isSeen: json['isSeen'],
    );
  }
}
