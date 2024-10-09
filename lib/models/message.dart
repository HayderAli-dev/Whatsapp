import 'package:whatsapp/commons/enums/message_enum.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime sentTime;
  final MessageEnum type;
  final String messageId;
  final bool isSeen;
  final String repliedMessage;
  final String repliedTo;
  final String repliedMessageType;

  Message(
    this.repliedMessage,
    this.repliedTo,
    this.repliedMessageType, {
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.sentTime,
    required this.type,
    required this.messageId,
    required this.isSeen,
  });

  
}
