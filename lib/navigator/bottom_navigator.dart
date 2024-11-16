import 'package:flutter/material.dart';
import 'package:jilijili/navigator/hi_navigator.dart';
import 'package:jilijili/pages/favorite_page.dart';
import 'package:jilijili/pages/home_page.dart';
import 'package:jilijili/pages/profile_page.dart';
import 'package:jilijili/pages/ranking_page.dart';
import 'package:jilijili/util/color.dart';
import 'package:jilijili/util/toast.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  static int initialPage = 0;
  final PageController _controller = PageController(initialPage: initialPage);
  final List<Widget> _pages = const [
    HomePage(),
    RankingPage(),
    FavoritePage(),
    ProfilePage()
  ];
  bool _hasBuild = false;
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    if (!_hasBuild) {
      HiNavigator.getInstance()
          .onBottomTabChange(initialPage, _pages[initialPage]);
      _hasBuild = true;
    }

    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => _onJumpTo(index, pageChanged: true),
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _onJumpTo(index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3),
        ],
      ),
    );
  }

  bool exitApp() {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt!) >
            const Duration(seconds: 2)) {
      showToast("再按一次退出应用");
      _lastPressedAt = DateTime.now();
      return false;
    }
    return true;
  }

  _bottomItem(String titile, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(icon, color: _defaultColor),
        activeIcon: Icon(icon, color: _activeColor),
        label: titile);
  }

  _onJumpTo(int index, {pageChanged = false}) {
    if (pageChanged) {
      HiNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    } else {
      _controller.jumpToPage(index);
    }

    setState(() {
      _currentIndex = index;
    });
  }
}
