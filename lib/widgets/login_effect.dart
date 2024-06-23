import 'package:flutter/material.dart';

class LoginEffect extends StatefulWidget {
  final bool protected;
  const LoginEffect({super.key, required this.protected});

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  Widget _image(bool isLeft) {
    var headLeft = widget.protected
        ? 'assets/images/head_left_protect.png'
        : 'assets/images/head_left.png';
    var headRight = widget.protected
        ? 'assets/images/head_right_protect.png'
        : 'assets/images/head_right.png';
    return Image(
      image: AssetImage(isLeft ? headLeft : headRight),
      height: 90,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          const Image(
            height: 50,
            width: 90,
            image: AssetImage('assets/images/logo.png'),
          ),
          _image(false),
        ],
      ),
    );
  }
}
