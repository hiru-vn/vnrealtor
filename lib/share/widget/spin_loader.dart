import 'package:flutter/material.dart';

Center kLoadingBubbleSpinner = Center(
  child: SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      backgroundColor: Colors.blue,
    ),
  ),
);

Center kLoadingSpinner = Center(
  child: SizedBox(
    height: 20,
    width: 20,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      backgroundColor: Colors.blue,
    ),
  ),
);

Function kLoadingBuilder =
    (BuildContext context, Widget child, ImageChunkEvent loadingProgress) =>
        loadingProgress != null ? kLoadingSpinner : child;

Function imageNetworkErrorBuilder = (_, __, ___) => SizedBox.shrink();
