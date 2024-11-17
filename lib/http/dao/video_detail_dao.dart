import 'package:jilijili/http/core/hi_net.dart';
import 'package:jilijili/http/request/video_detail_request.dart';
import 'package:jilijili/model/video_detail_model.dart';

class VideoDetailDao {
  static get(String vid) async {
    var request = VideoDetailRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    return VideoDetailModel.fromJson(result['data']);
  }
}
