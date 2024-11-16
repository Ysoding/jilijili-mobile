import 'package:flutter/material.dart';

enum StatusStyle { light, dark }

class CustomTopNavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const CustomTopNavigationBar(
      {super.key,
      this.statusStyle = StatusStyle.dark,
      this.color = Colors.white,
      this.height = 46,
      this.child});

  @override
  State<CustomTopNavigationBar> createState() => _CustomTopNavigationBarState();
}

class _CustomTopNavigationBarState extends State<CustomTopNavigationBar> {
  @override
  Widget build(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;

    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: widget.color),
      child: widget.child,
    );
  }
}
