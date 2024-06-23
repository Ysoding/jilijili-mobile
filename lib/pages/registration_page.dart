import 'package:flutter/material.dart';
import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/dao/login_dao.dart';
import 'package:jilijili/pages/login_page.dart';
import 'package:jilijili/util/string_util.dart';
import 'package:jilijili/util/toast.dart';
import 'package:jilijili/widgets/appbar.dart';
import 'package:jilijili/widgets/login_button.dart';
import 'package:jilijili/widgets/login_effect.dart';
import 'package:jilijili/widgets/login_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  String? username;
  String? password;
  String? rePassword;
  String? imoocId;
  String? orderId;

  void checkInput() {
    bool enable;
    if (isNotEmpty(username) &&
        isNotEmpty(password) &&
        isNotEmpty(rePassword) &&
        isNotEmpty(imoocId) &&
        isNotEmpty(orderId)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void checkParams() {
    String? tips;
    if (password != rePassword) {
      tips = '两次密码不一致';
    } else if (orderId?.length != 4) {
      tips = "请输入订单号的后四位";
    }

    if (tips != null) {
      showWarnToast(tips);
      return;
    }
    send();
  }

  void send() async {
    try {
      var result =
          await LoginDao.registration(username!, password!, imoocId!, orderId!);
      if (result['code'] == 0) {
        showToast('注册成功');
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
        appBar: appBar("注册", "登录", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }),
        body: ListView(children: [
          LoginEffect(protected: protect),
          LoginInput(
            title: '用户名',
            hint: '请输入用户名',
            onChanged: (text) {
              username = text;
              checkInput();
            },
          ),
          LoginInput(
            title: '密码',
            hint: '请输入密码',
            obscureText: true,
            onChanged: (text) {
              password = text;
              checkInput();
            },
            onFocused: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          LoginInput(
            title: '确认密码',
            hint: '请再次输入密码',
            lineStretch: true,
            obscureText: true,
            onChanged: (text) {
              rePassword = text;
              checkInput();
            },
            onFocused: (focus) {
              setState(() {
                protect = focus;
              });
            },
          ),
          LoginInput(
            title: '慕课网ID',
            hint: '请输入你的慕课网用户ID',
            keyboardType: TextInputType.number,
            onChanged: (text) {
              imoocId = text;
              checkInput();
            },
          ),
          LoginInput(
            title: '课程订单号',
            hint: '请输入课程订单号后四位',
            keyboardType: TextInputType.number,
            lineStretch: true,
            onChanged: (text) {
              orderId = text;
              checkInput();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LoginButton(
              title: '注册',
              enable: loginEnable,
              onPressed: checkParams,
            ),
          )
        ]));
  }
}
