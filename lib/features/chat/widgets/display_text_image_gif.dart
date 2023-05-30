import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
    this.fileWidth,
    this.fileHeight,
  });

  final String message;
  final MessageEnum type;
  final double? fileWidth;
  final double? fileHeight;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.image
            ? CachedNetworkImage(
                imageUrl: message,
                width: fileWidth,
                height: fileHeight,
              )
            : type == MessageEnum.audio
                ? StatefulBuilder(
                    builder: (context, setState) {
                      return IconButton(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                        ),
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer.play(UrlSource(message));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                        icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_circle),
                      );
                    },
                  )
                : type == MessageEnum.video
                    ? SizedBox(
                        width: fileWidth,
                        height: fileHeight,
                        child: VideoPlayerItem(
                          videoUrl: message,
                        ),
                      )
                    : type == MessageEnum.gif
                        ? CachedNetworkImage(
                            imageUrl: message,
                            width: fileWidth,
                            height: fileHeight,
                          )
                        : const Center(
                            child: Text(
                              "❌❌❌ You can't view this message with your version of the app. Please update.",
                              style: TextStyle(
                                // color: Colors.red,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          );
  }
}
