import 'package:flutter/material.dart';
import 'package:jilijili/model/video_detail_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoDetailModel videoDetailModel;
  const VideoDetailPage({super.key, required this.videoDetailModel});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Text("视频详情页,vid:${widget.videoDetailModel.vid}"),
    );
  }
}
