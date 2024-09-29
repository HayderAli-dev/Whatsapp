import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/commons/enums/message_enum.dart';
import 'package:whatsapp/commons/utils/utils.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({super.key, required this.receiverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  final TextEditingController _controller = TextEditingController();
  double _fieldHeight = 50; // Initial height of the input field
  bool isShowSend = false;

  void _updateHeight() {
    final text = _controller.text;
    final span = TextSpan(text: text, style: const TextStyle(fontSize: 16.0));
    final painter = TextPainter(
      text: span,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    painter.layout(
        maxWidth: MediaQuery.of(context).size.width - 100); // Adjust for icons
    setState(() {
      _fieldHeight = painter.size.height + 20;
      // some padding
    });
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void sendMessage() async {
    if (isShowSend) {
      ref.watch(chatControllerProvider).sendTextMessage(
          context, _controller.text.trim(), widget.receiverUserId);
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum)  {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: mobileChatBoxColor,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.emoji_emotions, color: Colors.grey),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 50,
                maxHeight: 120, // Maximum height of the input field
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  _updateHeight(); // Update height on text change
                  // Check if the text field is empty
                  if (value.isNotEmpty) {
                    // Change icon back to microphone
                    setState(() {
                      isShowSend = true;
                    });
                  } else {
                    // Change icon to send
                    setState(() {
                      isShowSend = false;
                    });
                  }
                },
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                ),
                maxLines: null,
                // Allow unlimited lines
                minLines: 1,
              ),
            ),
          ),
          IconButton(
            onPressed:selectImage,
            icon: const Icon(Icons.camera_alt, color: Colors.grey),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file, color: Colors.grey),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: tabColor,
            child: IconButton(
              onPressed: () {
                // Send message logic
                sendMessage();
                isShowSend = false;
                _controller.clear(); // Clear the input field after sending
                _updateHeight(); // Reset heig
              },
              icon: isShowSend
                  ? const Icon(Icons.send, color: Colors.white)
                  : const Icon(
                      Icons.mic,
                      color: Colors.white,
                    ), // Send button
            ),
          ),
        ],
      ),
    );
  }
}
