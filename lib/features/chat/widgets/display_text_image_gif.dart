import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/commons/enums/message_enum.dart';
import 'package:whatsapp/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  final MessageEnum type;
  final String message;

  const DisplayTextImageGif(
      {super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(message, style: const TextStyle(fontSize: 16))
        : type == MessageEnum.image
            ? CachedNetworkImage(imageUrl: message)
            : type == MessageEnum.video
                ? VideoPlayerItem(videoURL: message)
                : type == MessageEnum.image
                    ? CachedNetworkImage(imageUrl: message)
                    :type==MessageEnum.gif?CachedNetworkImage(imageUrl: message): StatefulBuilder(builder: (context, setState) {
                        return IconButton(
                            constraints: const BoxConstraints(minWidth: 100),
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                                setState((){
                                  isPlaying = false;
                                });

                              } else {
                                await audioPlayer.play(UrlSource(message),
                                    volume: 1);
                                setState((){
                                  isPlaying = true;
                                });
                              }
                            },
                            icon: isPlaying
                                ? const Icon(Icons.pause_circle)
                                : const Icon(Icons.play_circle));
                      });
  }
}
