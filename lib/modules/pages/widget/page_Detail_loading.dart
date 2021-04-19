import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class PageDetailLoading extends StatefulWidget {
  @override
  _PageDetailLoadingState createState() => _PageDetailLoadingState();
}

class _PageDetailLoadingState extends State<PageDetailLoading> {
  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
        builder: Container(
          child: Column(
            children: [
              _buildBanner(),
               _buildHeader(),
              _itemDivider(),
              _buildInfoPage(),
            ],
          ),
        )
    );
  }


  Widget _buildBanner() => Container(
    height: deviceWidth(context) / 2,
    decoration: BoxDecoration(
      color: Colors.white,
    ),
  );

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _itemHeaderInfo(),
            ),
          ],
        ),
        heightSpace(25),
        _buildContainerButtonsToolCreatePost(),
        heightSpace(10),
      ],
    ),
  );

  Widget _itemHeaderInfo() => Row(
    children: [
      Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      SizedBox(width: 16),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                width: 150,
                height: 12,
              ),
              SizedBox(width: 8),
            ],
          ),
          SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            width: 100,
            height: 12,
          ),
        ],
      )
    ],
  );

  Widget _buildContainerButtonsToolCreatePost() => Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Colors.white,
            ),
          ),
        ),
        widthSpace(20),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
          ),
        )
      ],
    ),
  );

  Widget _buildInfoPage() => Container(
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemInfoPage(),
        _itemInfoPage(),
        _itemInfoPage(),
        _itemInfoPage()
      ],
    ),
  );

  Widget _itemInfoPage() {
   return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          widthSpace(15),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            width: 150,
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _itemDivider() => Container(
    height: 10,
    width: double.infinity,
    color: Colors.white,
  );
}
