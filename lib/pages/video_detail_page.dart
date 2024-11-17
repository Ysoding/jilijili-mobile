import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/dao/video_detail_dao.dart';
import 'package:jilijili/model/video_detail_model.dart';
import 'package:jilijili/model/video_model.dart';
import 'package:jilijili/util/toast.dart';
import 'package:jilijili/widgets/custom_navigation_bar.dart';
import 'package:jilijili/widgets/hi_tab.dart';
import 'package:jilijili/widgets/video_header.dart';
import 'package:jilijili/widgets/video_large_card.dart';
import 'package:jilijili/widgets/video_view.dart';
import 'package:jilijili/widgets/view_util.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel? videoModel;
  const VideoDetailPage(this.videoModel, {super.key});

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  VideoModel? videoInfo;
  VideoDetailModel? detailInfo;
  List<VideoModel> videoList = [];

  List<String> tabs = ['简介', '评论'];
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    videoInfo = widget.videoModel;
    changeStatusBar(color: Colors.black, statusStyle: StatusStyle.lightContent);
    _loadData();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: videoInfo!.url != null
              ? Column(
                  children: [
                    // ios 黑色状态栏
                    CustomTopNavigationBar(
                      color: Colors.black,
                      statusStyle: StatusStyle.lightContent,
                      height: Platform.isAndroid ? 0 : 46,
                    ),
                    _buildVideoView(),
                    _buildTabNavigation(),
                    Flexible(
                        child: TabBarView(
                      controller: _controller,
                      children: [
                        _buildDetailList(),
                        const Text("敬请期待..."),
                      ],
                    )),
                  ],
                )
              : Container()),
    );
  }

  /// 播放器
  Widget _buildVideoView() {
    return VideoView(
      videoInfo!.url!,
      cover: videoInfo!.cover!,
    );
  }

  List<Widget> _buildVideoList() {
    return videoList.map((e) => VideoLargeCard(videoInfo: e)).toList();
  }

  /// 底部
  Widget _buildTabNavigation() {
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tabBar()],
        ),
      ),
    );
  }

  Widget _tabBar() {
    return HiTab(
      tabs.map((e) {
        return Tab(text: e);
      }).toList(),
      controller: _controller,
    );
  }

  Widget _buildDetailList() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        ..._buildContents(),
        ..._buildVideoList(),
      ],
    );
  }

  List<Widget> _buildContents() {
    return [
      VideoHeader(
        owner: videoInfo!.owner,
      )
    ];
  }

  void _loadData() async {
    try {
      VideoDetailModel res = await VideoDetailDao.get(videoInfo!.vid);
      setState(() {
        detailInfo = res;
        videoInfo = res.videoInfo;
        videoList = res.videoList;
      });
    } on NeedLogin catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }
}
