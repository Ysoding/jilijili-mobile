import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jilijili/navigator/hi_navigator.dart';
import 'package:jilijili/pages/profile_page.dart';
import 'package:jilijili/pages/video_detail_page.dart';

import 'package:jilijili/widgets/custom_navigation_bar.dart';

borderLine(BuildContext context, {bottom = true, top = false}) {
  // var themeProvider = context.watch<ThemeProvider>();
  // var lineColor = themeProvider.isDark() ? Colors.grey : Colors.grey[200];
  BorderSide borderSide = BorderSide(width: 0.5, color: Colors.green[200]!);
  return Border(
    bottom: bottom ? borderSide : BorderSide.none,
    top: top ? borderSide : BorderSide.none,
  );
}

BoxDecoration? bottomBoxShadow(BuildContext context) {
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: const Offset(0, 5),
        blurRadius: 5.0,
        spreadRadius: 1)
  ]);
}

Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) => Container(
      color: Colors.grey[200],
    ),
    errorWidget: (
      BuildContext context,
      String url,
      dynamic error,
    ) =>
        const Icon(Icons.error),
    imageUrl: url,
  );
}

///修改状态栏
void changeStatusBar(
    {color = Colors.white,
    StatusStyle statusStyle = StatusStyle.darkContent,
    BuildContext? context}) {
  var page = HiNavigator.getInstance().getCurrent()?.page;
  // fix Android切换 profile页面状态栏变白问题
  if (page is ProfilePage) {
    color = Colors.transparent;
  } else if (page is VideoDetailPage) {
    color = Colors.black;
    statusStyle = StatusStyle.lightContent;
  }
  // 沉浸式状态栏样式
  Brightness brightness;
  if (Platform.isIOS) {
    brightness = statusStyle == StatusStyle.lightContent
        ? Brightness.dark
        : Brightness.light;
  } else {
    brightness = statusStyle == StatusStyle.lightContent
        ? Brightness.light
        : Brightness.dark;
  }
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ),
  );
}
