import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  const ShimmerWidget.rectangular(
      {this.width = double.infinity,
      @required this.height,
      this.shapeBorder = const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))});

  const ShimmerWidget.cirular({@required this.width, @required this.height})
      : this.shapeBorder = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350],
      highlightColor: Colors.grey[200],
      child: Container(
          width: width,
          height: height,
          decoration:
              ShapeDecoration(color: Colors.grey[400], shape: shapeBorder)),
    );
  }
}
