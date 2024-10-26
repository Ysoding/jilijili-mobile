import 'package:flutter/material.dart';
import 'package:jilijili/util/logging.dart';

abstract class HiState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      mainLogger.warning("HiState: 页面已销毁，本次setState不执行：${toString()}");
    }
  }
}
