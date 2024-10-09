import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder3/flutter_audio_recorder3.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/Widgets/message_reply_preview.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/commons/enums/message_enum.dart';
import 'package:whatsapp/commons/providers/message_reply_provider.dart';
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
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  FlutterAudioRecorder3? _recorder;
  bool _isRecording = false;
  bool _isInitialized = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _isInitialized = false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openAudio();
  }

  Future<void> openAudio() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      final tempDir = await getTemporaryDirectory();
      var path =
          '${tempDir.path}/flutter_voice.m4a'; // Change file format if needed
      _recorder = FlutterAudioRecorder3(path);
      await _recorder!.initialized;
      setState(() {
        _isInitialized = true;
      });
    } else {
      showSnackBar(context: context, content: 'Microphone permission denied');
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void hideKeyboard() => focusNode.unfocus();

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void toggleRecording() async {
    if (_isRecording) {
      var result = await _recorder!.stop();
      File file = File(result!.path!);
      sendFileMessage(file, MessageEnum.audio);
      setState(() {
        _isRecording = false;
      });
    } else {
      await _recorder!.start();
      setState(() {
        _isRecording = true;
      });
    }
  }

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

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void selectGIF() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref
          .read(chatControllerProvider)
          .sendGIFMessage(context, gif.url, widget.receiverUserId);
    }
  }

  void sendTextMessage() async {
    if (isShowSend) {
      ref.watch(chatControllerProvider).sendTextMessage(
          context, _controller.text.trim(), widget.receiverUserId);
      isShowSend = false;
      _controller.clear(); // Clear the input field after sending
      _updateHeight();
    } else {
      toggleRecording();
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref
        .read(chatControllerProvider)
        .sendFileMessage(context, file, widget.receiverUserId, messageEnum);
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: mobileChatBoxColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: toggleEmojiKeyboardContainer,
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: selectGIF,
                    icon: const Icon(Icons.gif, color: Colors.grey),
                  ),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
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
                        focusNode: focusNode,
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
                    onPressed: selectImage,
                    icon: const Icon(Icons.camera_alt, color: Colors.grey),
                  ),
                  IconButton(
                    onPressed: selectVideo,
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: tabColor,
                    child: IconButton(
                      onPressed: sendTextMessage,
                      icon: isShowSend
                          ? const Icon(Icons.send, color: Colors.white)
                          : _isRecording
                              ? const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )
                              : const Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                ), // Send button
                    ),
                  ),
                ],
              ),
              isShowEmojiContainer
                  ? SizedBox(
                      height: 310,
                      child: EmojiPicker(
                        onEmojiSelected: ((category, emoji) {
                          setState(() {
                            _controller.text = _controller.text + emoji.emoji;
                            if (_controller.text.isNotEmpty) {
                              setState(() {
                                isShowSend = true;
                              });
                            }
                          });
                        }),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ],
    );
  }
}
