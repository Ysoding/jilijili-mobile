import 'dart:convert';

import 'package:jilijili/model/banner_model.dart';
import 'package:jilijili/model/category_model.dart';
import 'package:jilijili/model/video_model.dart';
import 'package:jilijili/util/model_util.dart';

class HomeModel {
  List<BannerModel>? bannerList;
  List<CategoryModel>? categoryList;
  List<VideoModel> videoList;

  HomeModel({
    this.bannerList,
    this.categoryList,
    required this.videoList,
  });

  factory HomeModel.fromJson(Map<String, dynamic> jsonRes) {
    final List<BannerModel>? bannerList =
        jsonRes['bannerList'] is List ? <BannerModel>[] : null;
    if (bannerList != null) {
      for (final dynamic item in jsonRes['bannerList']!) {
        if (item != null) {
          bannerList
              .add(BannerModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<CategoryModel>? categoryList =
        jsonRes['categoryList'] is List ? <CategoryModel>[] : null;
    if (categoryList != null) {
      for (final dynamic item in jsonRes['categoryList']!) {
        if (item != null) {
          categoryList
              .add(CategoryModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<VideoModel>? videoList =
        jsonRes['videoList'] is List ? <VideoModel>[] : null;
    if (videoList != null) {
      for (final dynamic item in jsonRes['videoList']!) {
        if (item != null) {
          videoList.add(VideoModel.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return HomeModel(
      bannerList: bannerList,
      categoryList: categoryList,
      videoList: videoList!,
    );
  }

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'bannerList': bannerList,
        'categoryList': categoryList,
        'videoList': videoList,
      };

  HomeModel clone() => HomeModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
