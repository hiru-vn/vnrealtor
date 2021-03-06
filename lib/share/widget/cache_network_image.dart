import 'package:datcao/share/widget/spin_loader.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CacheImage extends StatelessWidget {
  final String url;

  const CacheImage(this.url);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          kLoadingBubbleSpinner,
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
