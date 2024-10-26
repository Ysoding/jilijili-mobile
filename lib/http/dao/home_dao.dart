import 'package:jilijili/http/core/hi_net.dart';
import 'package:jilijili/http/request/home_request.dart';
import 'package:jilijili/model/home_model.dart';

class HomeDao {
  // https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
  static Future<HomeModel> get(String categoryName,
      {int pageIndex = 1, int pageSize = 10}) async {
    var req = HomeRequest();
    req.pathParams = categoryName;
    req.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(req);
    return HomeModel.fromJson(result['data']);
  }
}
