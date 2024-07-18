import 'package:flutter/material.dart';
import 'package:jilijili/pages/home_page.dart';
import 'package:jilijili/pages/login_page.dart';
import 'package:jilijili/pages/registration_page.dart';

enum RouteStatus { login, registration, home, detail, darkMode, unknown }

RouteStatus getRouteStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
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

  /// 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
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
