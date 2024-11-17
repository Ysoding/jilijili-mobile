import 'dart:convert';
import 'package:jilijili/model/owner_model.dart';
import 'package:jilijili/util/model_util.dart';

class VideoModel {
  VideoModel({
    this.id,
    required this.vid,
    this.title,
    this.tname,
    this.url,
    this.cover,
    this.pubdate,
    this.desc,
    this.view,
    this.duration,
    this.owner,
    this.reply,
    this.favorite,
    this.like,
    this.coin,
    this.share,
    this.createTime,
    this.size,
  });

  factory VideoModel.fromJson(Map<String, dynamic> jsonRes) => VideoModel(
        id: asT<String>(jsonRes['id'])!,
        vid: asT<String>(jsonRes['vid'])!,
        title: asT<String>(jsonRes['title'])!,
        tname: asT<String>(jsonRes['tname'])!,
        url: asT<String>(jsonRes['url'])!,
        cover: asT<String>(jsonRes['cover'])!,
        pubdate: asT<int>(jsonRes['pubdate'])!,
        desc: asT<String>(jsonRes['desc'])!,
        view: asT<int>(jsonRes['view'])!,
        duration: asT<int>(jsonRes['duration'])!,
        owner: Owner.fromJson(asT<Map<String, dynamic>>(jsonRes['owner'])!),
        reply: asT<int>(jsonRes['reply'])!,
        favorite: asT<int>(jsonRes['favorite'])!,
        like: asT<int>(jsonRes['like'])!,
        coin: asT<int>(jsonRes['coin'])!,
        share: asT<int>(jsonRes['share'])!,
        createTime: asT<String>(jsonRes['createTime'])!,
        size: asT<int>(jsonRes['size'])!,
      );

  String? id;
  String vid;
  String? title;
  String? tname;
  String? url;
  String? cover;
  int? pubdate;
  String? desc;
  int? view;
  int? duration;
  Owner? owner;
  int? reply;
  int? favorite;
  int? like;
  int? coin;
  int? share;
  String? createTime;
  int? size;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'vid': vid,
        'title': title,
        'tname': tname,
        'url': url,
        'cover': cover,
        'pubdate': pubdate,
        'desc': desc,
        'view': view,
        'duration': duration,
        'owner': owner,
        'reply': reply,
        'favorite': favorite,
        'like': like,
        'coin': coin,
        'share': share,
        'createTime': createTime,
        'size': size,
      };

  VideoModel clone() => VideoModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
