import 'package:datcao/resources/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class OwnPageLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        padding: const EdgeInsets.only(bottom: 19, top: 11),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: AppColors.borderGrayColor.withOpacity(0.3),
            width: 0.5,
          ),
        )),
        child: Row(
          children: <Widget>[
            Container(
              width: 45,
              height: 45,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    height: 10,
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    width: 100,
                    height: 12,
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
