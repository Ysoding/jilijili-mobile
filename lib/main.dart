import 'package:flutter/material.dart';
import 'package:jilijili/db/hi_cache.dart';
import 'package:jilijili/http/dao/login_dao.dart';
import 'package:jilijili/model/video_model.dart';
import 'package:jilijili/navigator/bottom_navigator.dart';
import 'package:jilijili/navigator/hi_navigator.dart';
import 'package:jilijili/pages/login_page.dart';
import 'package:jilijili/pages/registration_page.dart';
import 'package:jilijili/pages/video_detail_page.dart';
import 'package:jilijili/util/color.dart';
import 'package:jilijili/util/logging.dart';
import 'package:jilijili/util/toast.dart';

void main() {
  setupLogging();
  runApp(const JiliApp());
}

class JiliApp extends StatefulWidget {
  const JiliApp({super.key});

  @override
  State<JiliApp> createState() => _JiliAppState();
}

class _JiliAppState extends State<JiliApp> {
  final JiliRouteDelegate _routeDelegate = JiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(
                  routerDelegate: _routeDelegate,
                )
              : const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
            title: '姬哩姬哩',
          );
        });
  }
}

class JiliRoutePath {
  final String location;

  JiliRoutePath.home() : location = '/';
  JiliRoutePath.detail() : location = '/detail';
}

class JiliRouteDelegate extends RouterDelegate<JiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<JiliRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

  // 为 Navigator 设置一个 key，必要时可以通过navigatorKey.currentState 来获取到 navigatorState 对象
  JiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    HiNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        videoModel = args?['videoInfo'];
      }
      notifyListeners();
    }));
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    }
    return _routeStatus;
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;

  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    var tempPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      // tips 具体规则可以根据需要进行调整，这里要求栈中只允许有一个同样的页面的实例
      tempPages = tempPages.sublist(0, index);
    }

    late MaterialPage page;
    if (routeStatus == RouteStatus.home) {
      // 跳转首页时将栈中其它页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(const BottomNavigator());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(const RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    }

    // 重新创建一个数组，否则pages因引用没有改变路由不会生效
    tempPages = [...tempPages, page];
    HiNavigator.getInstance().notify(tempPages, pages);
    pages = tempPages;

    return PopScope(
        // fix Android物理返回键，无法返回上一页问题
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) {
            return;
          }
          final bool v =
              !(await navigatorKey.currentState?.maybePop() ?? false);
          if (context.mounted && v) {
            Navigator.pop(context);
          }
        },
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            // 登录页未登录返回拦截
            if (route.settings is MaterialPage &&
                (route.settings as MaterialPage).child is LoginPage) {
              if (!hasLogin) {
                showWarnToast("请先登录");
                return false;
              }
            }

            if (!route.didPop(result)) {
              return false;
            }

            var tempPages = [...pages];
            pages.removeLast();
            HiNavigator.getInstance().notify(pages, tempPages);

            return true;
          },
        ));
  }

  @override
  Future<void> setNewRoutePath(JiliRoutePath configuration) async {}
}
