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
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 120,
                        height: 15,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 70,
                        height: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 12,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 12,
              color: Colors.white,
            ),
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.white,
            ),
          ],
        ),
      ),
      items: count,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}

class StorySkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              Container(
                height: 154,
                width: 119,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 154,
                width: 119,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 154,
                width: 119,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 154,
                width: 119,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 15),
              Container(
                height: 154,
                width: 119,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      items: 1,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}
