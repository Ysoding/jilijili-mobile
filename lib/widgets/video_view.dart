import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:jilijili/util/color.dart';
import 'package:jilijili/widgets/view_util.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  /// 播放地址
  final String url;

  /// 封面
  final String cover;

  /// 自动播放
  final bool autoPlay;

  /// 循环播放
  final bool looping;

  /// 视频缩放比例
  final double aspectRatio;

  const VideoView(
    this.url, {
    super.key,
    required this.cover,
    this.autoPlay = false,
    this.looping = false,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  /// video_player播放器Controller
  late VideoPlayerController _videoPlayerController;

  /// chewie播放器Controller
  late ChewieController _chewieController;

  /// 进度条颜色配置
  get _progressColors => ChewieProgressColors(
      playedColor: primary,
      handleColor: primary,
      backgroundColor: Colors.grey,
      bufferedColor: primary[50]!);

  /// 封面
  get _placeholder => FractionallySizedBox(
        widthFactor: 1,
        child: cachedImage(widget.cover),
      );

  @override
  void initState() {
    super.initState();

    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);

    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      placeholder: _placeholder,
      allowPlaybackSpeedChanging: false,
      materialProgressColors: _progressColors,
    );
    _chewieController.addListener(_fullScreenListener);
  }

  void _fullScreenListener() {
    if (_chewieController.isFullScreen) {
      // 切换到横屏
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
        }
      });
    }
  }

  @override
  void dispose() {
    _chewieController.removeListener(_fullScreenListener);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double playerHeight = screenWidth / widget.aspectRatio;

    return Container(
      width: screenWidth,
      height: playerHeight,
      color: Colors.grey,
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
