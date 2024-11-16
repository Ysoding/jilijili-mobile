import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

BoxDecoration? bottomBoxShadow(BuildContext context) {
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: const Offset(0, 5),
        blurRadius: 5.0,
        spreadRadius: 1)
  ]);
}

Widget cachedImage(String url, {double? width, double? height}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) => Container(
      color: Colors.grey[200],
    ),
    errorWidget: (
      BuildContext context,
      String url,
      dynamic error,
    ) =>
        const Icon(Icons.error),
    imageUrl: url,
  );
}
