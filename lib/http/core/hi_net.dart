import 'package:jilijili/http/core/dio_adaptor.dart';
import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/core/hi_net_adaptor.dart';
import 'package:jilijili/http/request/base_request.dart';
import 'package:logging/logging.dart';

class HiNet {
  HiNet._();
  static HiNet? _instance;
  static final log = Logger("HiNet");

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    log.info(request.header);

    try {
      response = await _send(request);
    } on HiNetError catch (e) {
      response = e.data;
      log.shout(e);
    }

    var result = response?.data;
    log.info(result);

// 使用Exepction的话没有显示的提示，可能会忘记try-catch
// 可以考虑再封装一层结果，使用pattern matching
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw AuthError("权限错误", data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<HiNetResponse<T>> _send<T>(BaseRequest request) async {
    HiNetAdaptor adapter = DioAdaptor();
    // HiNetAdaptor adapter = MockAdaptor();
    return adapter.send(request);
  }
}
