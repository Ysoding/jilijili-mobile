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
import 'package:jilijili/widgets/custom_navigation_bar.dart';
import 'package:jilijili/widgets/hi_tab.dart';
import 'package:jilijili/widgets/loading_container.dart';
import 'package:jilijili/widgets/view_util.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  const HomePage({super.key, this.onJumpTo});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  late RouteChangeListener listener;
  late TabController _tabController;
  List<CategoryModel> categoryList = [];
  List<BannerModel> bannerList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: categoryList.length, vsync: this);

    HiNavigator.getInstance().addListener(listener = (current, previous) {
      if (widget == current.page || current.page is HomePage) {
        mainLogger.info("打开了首页:onResume");
      } else if (widget == previous?.page || previous?.page is HomePage) {
        mainLogger.info("离开了首页:onPause");
      }
    });

    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HiNavigator.getInstance().removeListener(listener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: LoadingContainer(
      isLoading: isLoading,
      child: Column(
        children: [
          CustomTopNavigationBar(
            height: 50,
            color: Colors.white,
            statusStyle: StatusStyle.dark,
            child: _appBar(),
          ),
          Container(
            child: _tabBar(),
            decoration: bottomBoxShadow(context),
          ),
          Flexible(
              child: TabBarView(
            controller: _tabController,
            children: categoryList
                .map((tab) => HomeTabPage(
                      categoryName: tab.name,
                      bannerList: tab.name == '推荐' ? bannerList : null,
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

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: const Image(
                height: 46,
                width: 46,
                image: AssetImage('assets/images/avatar.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  height: 32,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(color: Colors.grey[100]),
                  child: const Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // _mockCrash();
            },
            child: const Icon(
              Icons.explore_outlined,
              color: Colors.grey,
            ),
          ),
          InkWell(
            onTap: () {
              HiNavigator.getInstance().onJumpTo(RouteStatus.notice);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 12),
              child: Icon(
                Icons.mail_outline,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _tabBar() {
    return HiTab(
      categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Text(
              tab.name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
      controller: _tabController,
      fontSize: 16,
      borderWidth: 3,
      unselectedLabelColor: Colors.black54,
      insets: 13,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
