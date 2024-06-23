import 'package:jilijili/db/hi_cache.dart';
import 'package:jilijili/http/core/hi_net.dart';
import 'package:jilijili/http/request/base_request.dart';
import 'package:jilijili/http/request/login_request.dart';
import 'package:jilijili/http/request/registration_request.dart';

class LoginDao {
  static const boardingPassKey = "boarding-pass";

  static login(String username, String password) {
    return _send(username, password);
  }

  static registration(
      String username, String password, String imoocId, String orderId) {
    return _send(username, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String username, String password,
      {String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
      request.add("imoocId", imoocId).add('orderId', orderId);
    } else {
      request = LoginRequest();
    }

    request.add("userName", username).add("password", password);

    var result = await HiNet.getInstance().fire(request);
    if (result['code'] == 0 && result['data'] != null) {
      // save token
      HiCache.getInstance().setString(boardingPassKey, result['data']);
    }
    return result;
  }

  static String? getBoardingPass() {
    return HiCache.getInstance().get(boardingPassKey);
  }
}
