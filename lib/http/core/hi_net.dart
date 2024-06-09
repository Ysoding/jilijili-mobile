import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/core/hi_net_adaptor.dart';
import 'package:jilijili/http/core/mock_adaptor.dart';
import 'package:jilijili/http/request/base_request.dart';

class HiNet implements HiNetAdaptor {
  HiNet._();
  static HiNet? _instance;

  static HiNet getInstance() {
    _instance ??= HiNet._();
    return _instance!;
  }

  Future fire(BaseRequest request) async {
    HiNetResponse? response;
    var error;

    try {
      response = await send(request);
    } on HiNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    }

    if (response == null) {
      printLog(error);
    }

    var result = response?.data;
    printLog(result);

    var status = response?.statusCode;
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw HiNetError(status ?? -1, result.toString(), data: result);
    }
  }

  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    HiNetAdaptor adapter = MockAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('hi_net:${log.toString()}');
  }
}
