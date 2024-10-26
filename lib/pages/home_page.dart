import 'package:flutter/material.dart';
import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/dao/home_dao.dart';
import 'package:jilijili/model/home_model.dart';
import 'package:jilijili/navigator/hi_navigator.dart';
import 'package:jilijili/pages/home_tab_page.dart';
import 'package:jilijili/util/color.dart';
import 'package:jilijili/util/hi_state.dart';
import 'package:jilijili/util/logging.dart';
import 'package:jilijili/util/toast.dart';
import 'package:jilijili/widgets/loading_container.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late RouteChangeListener listener;
  late TabController _tabController;
  List<CategoryModel> categoryList = [];
  List<BannerModel> bannerList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: categoryList.length, vsync: this);

    HiNavigator.getInstance().addListener(listener = (current, previous) {
      mainLogger.info("current:${current.page}");
      mainLogger.info("previous:${previous?.page}");

      if (widget == current.page || current.page is HomePage) {
        mainLogger.info("打开了首页:onResume");
      } else if (widget == previous?.page || previous?.page is HomePage) {
        mainLogger.info("离开了首页:onPause");
      }
    });

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: LoadingContainer(
      isLoading: isLoading,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: _tabBar(),
            padding: const EdgeInsets.only(top: 30),
          ),
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: categoryList
                .map((tab) => HomeTabPage(
                      categoryName: tab.name,
                      bannerList: tab.name == '推荐' ? bannerList : [],
                    ))
                .toList(),
          ))
        ],
      ),
    ));
  }

  void loadData() async {
    try {
      var res = await HomeDao.get("推荐");
      if (res.categoryList != null) {
        _tabController =
            TabController(length: res.categoryList?.length ?? 0, vsync: this);
      }
      setState(() {
        categoryList = res.categoryList ?? [];
        bannerList = res.bannerList ?? [];
        isLoading = false;
      });
    } on AuthError catch (e) {
      showWarnToast(e.message);
      setState(() {
        isLoading = false;
      });
    } on HiNetError catch (e) {
      showWarnToast(e.message);
      setState(() {
        isLoading = false;
      });
    }
  }

  _tabBar() {
    return TabBar(
      controller: _tabController,
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      labelColor: Colors.black,
      tabs: categoryList
          .map<Tab>((tab) => Tab(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    tab.name,
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
