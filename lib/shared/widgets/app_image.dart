import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({super.key, this.url, this.height, this.fit, this.width});

  final String? url;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url ?? '',
      fit: fit,
      height: height,
      width: width,
      placeholder: (_, _) => Center(child: CircularProgressIndicator()),
      errorWidget: (_, _, _) => Center(child: Icon(Icons.error)),
    );
  }
}
