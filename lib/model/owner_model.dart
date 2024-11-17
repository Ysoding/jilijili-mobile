import 'dart:convert';
import 'package:jilijili/util/model_util.dart';

class Owner {
  Owner({
    required this.name,
    required this.face,
    required this.fans,
  });

  factory Owner.fromJson(Map<String, dynamic> jsonRes) => Owner(
        name: asT<String>(jsonRes['name'])!,
        face: asT<String>(jsonRes['face'])!,
        fans: asT<int>(jsonRes['fans'])!,
      );

  String name;
  String face;
  int fans;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'face': face,
        'fans': fans,
      };

  Owner clone() =>
      Owner.fromJson(asT<Map<String, dynamic>>(jsonDecode(jsonEncode(this)))!);
}
