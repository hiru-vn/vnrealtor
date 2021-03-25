import 'package:flutter/material.dart';

Center kLoadingSpinner = Center(
  child: SizedBox(
    width: 20,
    height: 20,
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
