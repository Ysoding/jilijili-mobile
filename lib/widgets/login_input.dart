import 'package:flutter/material.dart';
import 'package:jilijili/util/color.dart';

class LoginInput extends StatefulWidget {
  final String title; // 标题
  final String hint; // 提示文本
  final bool lineStretch; // 下划线
  final bool obscureText; // 隐藏文本
  final TextInputType? keyboardType; // 键盘类型
  final ValueChanged<String>? onChanged; // 输入事件
  final ValueChanged<bool>? onFocused; // 聚集事件

  const LoginInput(
      {super.key,
      required this.title,
      required this.hint,
      this.keyboardType,
      this.onChanged,
      this.onFocused,
      this.lineStretch = false,
      this.obscureText = false});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (widget.onFocused != null) {
        widget.onFocused!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _input() {
    return Expanded(
        child: TextField(
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      autofocus: !widget.obscureText,
      cursorColor: primary,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        border: InputBorder.none,
        hintText: widget.hint,
        hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 15),
                width: 100,
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16),
                )),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: widget.lineStretch ? 15 : 0),
          child: const Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }
}
