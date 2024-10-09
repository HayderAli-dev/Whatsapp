import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videoURL;
  const VideoPlayerItem({super.key, required this.videoURL});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late CachedVideoPlayerController videoPlayerController;

  bool isPlay = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoURL)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
        videoPlayerController.addListener(() {
          if (videoPlayerController.value.position == videoPlayerController.value.duration) {
            // Reset the video to the start

           setState(() {
             videoPlayerController.seekTo(Duration.zero);
             isPlay=false;
             videoPlayerController.pause();

           });
          }
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  if (!isPlay) {
                   setState(() {
                     isPlay = true;
                     videoPlayerController.play();
                   });
                  } else {
                   setState(() async {
                    await videoPlayerController.pause();
                    isPlay = false;
                   });
                  }
                },
                icon: isPlay
                    ? const Icon(Icons.pause_circle)
                    : const Icon(Icons.play_circle)),
          )
        ],
      ),
    );
  }
}
