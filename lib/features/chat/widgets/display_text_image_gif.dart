import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_enum.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player_item.dart';

class DisplayTextImageGif extends StatelessWidget {
  const DisplayTextImageGif({
    super.key,
    required this.message,
    required this.type,
  });

  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
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
              )
            : type == MessageEnum.video
                ? VideoPlayerItem(
                    videoUrl: message,
                  )
                : type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
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