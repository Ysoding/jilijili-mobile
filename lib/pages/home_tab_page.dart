import 'package:flutter/material.dart';
import 'package:flutter_nested/flutter_nested.dart';
import 'package:jilijili/http/dao/home_dao.dart';
import 'package:jilijili/model/home_model.dart';
import 'package:jilijili/widgets/hi_banner.dart';
import 'package:jilijili/widgets/hi_base_tab_state.dart';
import 'package:jilijili/widgets/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel>? bannerList;

  const HomeTabPage({super.key, required this.categoryName, this.bannerList});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState
    extends HiBaseTabState<HomeModel, VideoModel, HomeTabPage> {
  _banner(List<BannerModel> bannerList) {
    return HiBanner(bannerList,
        padding: const EdgeInsets.only(left: 5, right: 5));
  }

  @override
  Future<HomeModel> getData(int pageIndex) async {
    HomeModel result =
        await HomeDao.get(widget.categoryName, pageIndex: pageIndex);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeModel result) {
    return result.videoList;
  }

  @override
  get contentChild => HiNestedScrollView(
        controller: scrollController,
        itemCount: dataList.length,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        headers: [
          if (widget.bannerList != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _banner(widget.bannerList!),
            ),
        ],
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.82),
        itemBuilder: (BuildContext context, int index) {
          return VideoCard(videoInfo: dataList[index]);
        },
      );
}
