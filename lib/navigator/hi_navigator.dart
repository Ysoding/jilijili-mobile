import 'package:flutter/material.dart';
import 'package:jilijili/navigator/bottom_navigator.dart';
import 'package:jilijili/pages/login_page.dart';
import 'package:jilijili/pages/registration_page.dart';
import 'package:jilijili/pages/video_detail_page.dart';

enum RouteStatus {
  login,
  registration,
  home,
  detail,
  darkMode,
  unknown,
  notice
}

typedef RouteChangeListener = void Function(
    RouteStatusInfo current, RouteStatusInfo? previous);

RouteStatus getRouteStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else {
    return RouteStatus.unknown;
  }
}

class RouteStatusInfo {
  final RouteStatus status;
  final Widget page;

  RouteStatusInfo(this.status, this.page);
}

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(child: child, key: ValueKey(child.hashCode));
}

/// 获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    var p = pages[i];
    if (getRouteStatus(p) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 监听路由页面跳转
/// 感知当前页面是否压后台
class HiNavigator extends _RouteJumpListener {
  static HiNavigator? _instance;

  RouteStatusInfo? _current;
  RouteJumpListener? _routeJump;
  RouteStatusInfo? _bottomTab;
  final List<RouteChangeListener> _listeners = [];

  HiNavigator._();

  static HiNavigator getInstance() {
    _instance ??= HiNavigator._();
    return _instance!;
  }

  RouteStatusInfo? getCurrent() {
    return _current;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  /// 首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomTab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomTab!);
  }

  /// 监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  /// 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJump = routeJumpListener;
  }

  /// 通知路由页面变化
  void notify(List<MaterialPage> currentPages, List<MaterialPage> prevPages) {
    if (currentPages == prevPages) return;
    var current = RouteStatusInfo(
        getRouteStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomTab != null) {
      current = _bottomTab!;
    }
    // mainLogger.info("hi_navigator:current:${current.page}");
    // mainLogger.info("hi_navigator:previous:${_current?.page}");
    for (var listener in _listeners) {
      listener(current, _current);
    }
    _current = current;
  }
}

/// 抽象类供HiNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus, {Map? args});

/// 定义路由跳转逻辑要实现的功能

class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
