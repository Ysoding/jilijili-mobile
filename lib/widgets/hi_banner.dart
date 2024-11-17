import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:jilijili/model/banner_model.dart';
import 'package:jilijili/util/logging.dart';

/// 轮播图
class HiBanner extends StatelessWidget {
  final List<BannerModel> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;

  const HiBanner(this.bannerList,
      {super.key, this.bannerHeight = 160, this.padding});

  /// banner 点击跳转
  void handleBannerClick(BannerModel banner) {
    if (banner.type == 'video') {
      mainLogger.info(banner.toString());
    } else {}
  }

  /// banner 图片
  Widget _image(BannerModel banner) {
    return InkWell(
      onTap: () {
        mainLogger.info(banner.title);
        handleBannerClick(banner);
      },
      child: Container(
        padding: padding,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Image.network(
            banner.cover ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    double right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) =>
          _image(bannerList[index]),
      pagination: SwiperPagination(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(right: right, bottom: 10),
        builder: const DotSwiperPaginationBuilder(
            color: Colors.white60, size: 6, activeSize: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerHeight,
      child: _banner(),
    );
  }
}
