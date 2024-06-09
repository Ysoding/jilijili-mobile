enum HttpMethod { GET, POST, DELETE }

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

    return uri.toString();
  }
}
