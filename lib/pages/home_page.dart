import 'package:flutter/material.dart';
import 'package:jilijili/model/video_detail_model.dart';
import 'package:jilijili/navigator/hi_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 200)),
          const Text('首页'),
          MaterialButton(
            onPressed: () =>
                HiNavigator.getInstance().onJumpTo(RouteStatus.detail, args: {
              "videoMo": VideoDetailModel(vid: 1111),
            }),
            child: Text("详细"),
          )
        ],
      ),
    );
  }
}
