import 'package:flutter/material.dart';
import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/dao/login_dao.dart';
import 'package:jilijili/navigator/hi_navigator.dart';
import 'package:jilijili/pages/registration_page.dart';
import 'package:jilijili/util/string_util.dart';
import 'package:jilijili/util/toast.dart';
import 'package:jilijili/widgets/appbar.dart';
import 'package:jilijili/widgets/login_button.dart';
import 'package:jilijili/widgets/login_effect.dart';
import 'package:jilijili/widgets/login_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // jvadd dddd112002
  // Tom2 123
  bool protected = false;
  bool loginEnable = false;
  String? username;
  String? password;

  void checkInput() {
    if (isNotEmpty(username) && isNotEmpty(password)) {
      setState(() {
        loginEnable = true;
      });
    } else {
      setState(() {
        loginEnable = false;
      });
    }
  }

  void login() async {
    try {
      var result = await LoginDao.login(username!, password!);
      if (result['code'] == 0) {
        showToast("登录成功");
        HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
      } else {
        showWarnToast(result['msg']);
      }
    } on AuthError catch (e) {
      showWarnToast(e.message);
    } on HiNetError catch (e) {
      showWarnToast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        '登录',
        '注册',
        () {
          HiNavigator.getInstance().onJumpTo(RouteStatus.registration);
        },
        key: const Key('registration'),
      ),
      body: ListView(
        children: [
          LoginEffect(protected: protected),
          LoginInput(
            title: '用户名',
            hint: '请输入用户',
            onChanged: (text) {
              username = text;
              checkInput();
            },
          ),
          LoginInput(
            title: '密码',
            hint: '请输入密码',
            obscureText: true,
            onChanged: (value) {
              password = value;
              checkInput();
            },
            onFocused: (value) => {
              setState(() {
                protected = value;
              })
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LoginButton(
              title: '登录',
              enable: loginEnable,
              onPressed: login,
            ),
          ),
        ],
      ),
    );
  }
}
