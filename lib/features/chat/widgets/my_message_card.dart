import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/commons/enums/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_gif.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageEnum type;
  final VoidCallback onSwipeLeft;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;

  const MyMessageCard(
      {super.key,
      required this.message,
      required this.time,
      required this.type,
      required this.onSwipeLeft,
      required this.repliedText,
      required this.userName,
      required this.repliedMessageType});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 45),
        child: Card(
          elevation: 1,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          color: messageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: type == MessageEnum.text
                    ? const EdgeInsets.only(
                        left: 10, right: 60, top: 5, bottom: 22)
                    : const EdgeInsets.only(
                        left: 5, right: 5, top: 5, bottom: 30),
                child: DisplayTextImageGif(type: type, message: message),
              ),
              Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.white60),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
