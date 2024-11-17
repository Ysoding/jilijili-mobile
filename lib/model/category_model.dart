import 'dart:convert';

import 'package:jilijili/util/model_util.dart';

class CategoryModel {
  CategoryModel({
    required this.name,
    required this.count,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> jsonRes) => CategoryModel(
        name: asT<String>(jsonRes['name'])!,
        count: asT<int>(jsonRes['count'])!,
      );

  String name;
  int count;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'count': count,
      };

  CategoryModel clone() => CategoryModel.fromJson(
      asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
