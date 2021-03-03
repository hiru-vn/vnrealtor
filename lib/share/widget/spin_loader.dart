import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Center kLoadingBubbleSpinner = Center(
  child: SizedBox(
    height: 50,
    width: 50,
    child: SpinKitCircle(
      color: Colors.greenAccent,
      size: 50.0,
    ),
  ),
);

Center kLoadingSpinner = Center(
  child: SizedBox(
    height: 60,
    width: 60,
    child: Image.asset('assets/image/loading_logo.gif'),
  ),
);

Function kLoadingBuilder =
    (BuildContext context, Widget child, ImageChunkEvent loadingProgress) =>
        loadingProgress != null ? kLoadingSpinner : child;

Function imageNetworkErrorBuilder = (_, __, ___) => SizedBox.shrink();
