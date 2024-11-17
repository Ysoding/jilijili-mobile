import 'package:flutter/material.dart';
import 'package:jilijili/model/video_model.dart';
import 'package:jilijili/widgets/view_util.dart';

class VideoLargeCard extends StatelessWidget {
  final VideoModel videoInfo;
  const VideoLargeCard({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        padding: const EdgeInsets.only(bottom: 6),
        height: 106,
        decoration: BoxDecoration(border: borderLine(context)),
        child: Text(videoInfo.title!),
      ),
    );
  }
}
