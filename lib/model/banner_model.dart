import 'dart:convert';

import 'package:jilijili/util/model_util.dart';

class BannerModel {
  BannerModel({
    required this.id,
    required this.sticky,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.url,
    this.cover,
    required this.createTime,
  });

  factory BannerModel.fromJson(Map<String, dynamic> jsonRes) => BannerModel(
        id: asT<String>(jsonRes['id'])!,
        sticky: asT<int>(jsonRes['sticky'])!,
        type: asT<String>(jsonRes['type'])!,
        title: asT<String>(jsonRes['title'])!,
        subtitle: asT<String>(jsonRes['subtitle'])!,
        url: asT<String>(jsonRes['url'])!,
        cover: jsonRes['cover'],
        createTime: asT<String>(jsonRes['createTime'])!,
      );

  String id;
  int sticky;
  String type;
  String title;
  String subtitle;
  String url;
  String? cover;
  String createTime;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sticky': sticky,
        'type': type,
        'title': title,
        'subtitle': subtitle,
        'url': url,
        'cover': cover,
        'createTime': createTime,
      };

  BannerModel clone() => BannerModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
