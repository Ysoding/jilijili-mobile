import 'package:flutter/material.dart';
import 'package:jilijili/navigator/hi_navigator.dart';
import 'package:jilijili/pages/home_tab_page.dart';
import 'package:jilijili/util/color.dart';
import 'package:jilijili/util/logging.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late RouteChangeListener listener;
  var tabs = ["推荐", "热门", "动画", "影视", "搞笑", "日常"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: tabs.length, vsync: this);

    HiNavigator.getInstance().addListener(listener = (current, previous) {
      mainLogger.info("current:${current.page}");
      mainLogger.info("previous:${previous?.page}");

      if (widget == current.page || current.page is HomePage) {
        mainLogger.info("打开了首页:onResume");
      } else if (widget == previous?.page || previous?.page is HomePage) {
        mainLogger.info("离开了首页:onPause");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: _tabBar(),
            padding: const EdgeInsets.only(top: 30),
          ),
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: tabs.map((e) => HomeTabPage(name: e)).toList(),
          ))
        ],
      ),
    );
  }

  _tabBar() {
    return TabBar(
      controller: _tabController,
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      labelColor: Colors.black,
      tabs: tabs
          .map<Tab>((e) => Tab(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 15),
                  ))))
          .toList(),
      indicator: const UnderlineIndicator(
          strokeCap: StrokeCap.round,
          insets: EdgeInsets.only(right: 15, left: 15),
          borderSide: BorderSide(color: primary, width: 3)),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
