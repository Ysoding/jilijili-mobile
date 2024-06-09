import 'package:dio/dio.dart';
import 'package:jilijili/http/core/hi_error.dart';
import 'package:jilijili/http/core/hi_net_adaptor.dart';
import 'package:jilijili/http/request/base_request.dart';

class DioAdaptor extends HiNetAdaptor {
  @override
  Future<HiNetResponse<T>> send<T>(BaseRequest request) async {
    Response? response;
    var options = Options(headers: request.header);

    try {
      switch (request.httpMethod()) {
        case HttpMethod.GET:
          response = await Dio().get(request.url(), options: options);
          break;
        case HttpMethod.DELETE:
          response = await Dio()
              .delete(request.url(), data: request.params, options: options);
          break;
        case HttpMethod.POST:
          response = await Dio()
              .post(request.url(), data: request.params, options: options);
          break;
      }
    } on DioException catch (e) {
      throw HiNetError(e.response?.statusCode ?? -1, e.toString(),
          data: await buildRes(e.response, request));
    }

    return buildRes(response, request);
  }

  Future<HiNetResponse<T>> buildRes<T>(
      Response? response, BaseRequest request) {
    return Future.value(HiNetResponse(
      data: response?.data,
      request: request,
      statusCode: response?.statusCode,
      statusMessage: response?.statusMessage,
      extra: response,
    ));
  }
}
