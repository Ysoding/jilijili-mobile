import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showWarnToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: const Color(0xfffb7299),
    textColor: Colors.white,
  );
}

void showToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}
