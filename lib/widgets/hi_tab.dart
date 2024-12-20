import 'package:flutter/material.dart';
import 'package:jilijili/util/color.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HiTab extends StatelessWidget {
  /// 标签列表
  final List<Widget> tabs;

  /// 控制器
  final TabController? controller;

  /// 字体大小
  final double fontSize;

  /// 边框宽度
  final double borderWidth;

  /// 左右间距
  final double insets;

  /// 未选中颜色
  final Color unselectedLabelColor;

  const HiTab(
    this.tabs, {
    super.key,
    this.controller,
    this.fontSize = 13,
    this.borderWidth = 2,
    this.insets = 15,
    this.unselectedLabelColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    // var themeProvider = context.watch<ThemeProvider>();
    // var _unselectedLabelColor =
    // themeProvider.isDark() ? Colors.white70 : unselectedLabelColor;
    return TabBar(
      tabAlignment: TabAlignment.start,
      controller: controller,
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: unselectedLabelColor,
      labelStyle: TextStyle(fontSize: fontSize),
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.square,
          borderSide: BorderSide(color: primary, width: borderWidth),
          insets: EdgeInsets.only(left: insets, right: insets)),
      tabs: tabs,
    );
  }
}
