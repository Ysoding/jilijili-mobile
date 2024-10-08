import 'package:jilijili/http/core/hi_net_adaptor.dart';
import 'package:jilijili/http/request/base_request.dart';

///测试适配器，mock数据
class MockAdaptor extends HiNetAdaptor {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    return Future.delayed(const Duration(milliseconds: 1000), () {
      return HiNetResponse(
          request: request,
          data: {"code": 0, "message": 'success'} as T,
          statusCode: 403);
    });
  }
}
