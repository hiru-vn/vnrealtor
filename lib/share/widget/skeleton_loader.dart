import 'package:datcao/modules/inbox/import/color.dart';
import 'package:datcao/share/widget/loading_widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ListSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      items: 3,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}

class PostSkeleton extends StatelessWidget {
  final int count;

  const PostSkeleton({Key key, this.count = 2}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              ShimmerWidget.cirular(width: 50, height: 50),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ShimmerWidget.rectangular(
                      height: 15,
                      width: 120,
                    ),
                    SizedBox(height: 10),
                    ShimmerWidget.rectangular(
                      height: 12,
                      width: 70,
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 15),
          ShimmerWidget.rectangular(
            height: 12,
          ),
          SizedBox(height: 10),
          ShimmerWidget.rectangular(
            height: 12,
          ),
          SizedBox(height: 15),
          ShimmerWidget.rectangular(
            height: 150,
          ),
        ],
      ),
    );
  }
}

class StorySkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 12,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) =>
              ShimmerWidget.cirular(width: 70, height: 70),
        ),
      ),
    );
  }
}
