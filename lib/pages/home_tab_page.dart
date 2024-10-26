import 'package:flutter/material.dart';
import 'package:jilijili/model/home_model.dart';
import 'package:jilijili/widgets/hi_banner.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerModel> bannerList;

  const HomeTabPage(
      {super.key, required this.categoryName, required this.bannerList});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  _banner() {
    return HiBanner(widget.bannerList,
        padding: const EdgeInsets.only(left: 5, right: 5));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [if (widget.bannerList != null) _banner()],
    );
  }
}
