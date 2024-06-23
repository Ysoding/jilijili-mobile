import 'package:jilijili/http/dao/login_dao.dart';
import 'package:jilijili/util/constants.dart';

enum HttpMethod { get, post, delete }

abstract class BaseRequest {
  // curl -X GET "http://api.devio.org/uapi/test/test?requestPrams=11" -H "accept: */*"
  // curl -X GET "https://api.devio.org/uapi/test/test/1
  String pathParams = "";
  var useHttps = true;

  bool needLogin();
  Map<String, String> params = {};

  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {};

  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();

    return this;
  }

  BaseRequest addHeaders(Map<String, dynamic> more) {
    more.forEach((key, value) {
      header[key] = value.toString();
    });

    return this;
  }

  String authority() {
    return "api.devio.org";
  }

  HttpMethod httpMethod();

  String path();

  String url() {
    Uri uri;
    var pathStr = path();

    if (pathParams != "") {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }

    _updateHeader();
    return uri.toString();
  }

  _updateHeader() {
    if (needLogin()) {
      addHeader(LoginDao.boardingPassKey, LoginDao.getBoardingPass() ?? "");
    }
    addHeaders(Constants.headers);
  }
}
