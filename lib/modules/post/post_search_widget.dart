import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/share/function/share_to.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:readmore/readmore.dart';
import 'package:popup_menu/popup_menu.dart';

import 'comment_page.dart';

class PostSearchWidget extends StatefulWidget {
  @override
  _PostSearchWidgetState createState() => _PostSearchWidgetState();
}

class _PostSearchWidgetState extends State<PostSearchWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: deviceWidth(context),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  GestureDetector(
                  onTap: () {
                    ProfilePage.navigate();
                  },
                  child:CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage('assets/image/avatar.jpg'),
                  ),),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nguyễn Hùng',
                        style: ptTitle(),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          Text(
                            '3',
                            style: ptTitle().copyWith(color: Colors.yellow),
                          ),
                          SizedBox(width: 2),
                          Image.asset('assets/image/coin.png'),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Center(
                    child: IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15).copyWith(top: 0),
              child: ReadMoreText(
                'Flutter is Google’s mobile UI open source framework to build high-quality native (super fast) interfaces for iOS and Android apps with the unified codebase.',
                trimLines: 2,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: deviceWidth(context) / 2 - 5,
              width: deviceWidth(context),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    width: deviceWidth(context) / 2 - 5,
                    height: deviceWidth(context) / 2 - 5,
                    child: ImageViewNetwork(
                      url:
                          'https://i.pinimg.com/originals/38/d7/5b/38d75b985d9d08ce0959201f8198f405.jpg',
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    width: deviceWidth(context) / 2 - 5,
                    height: deviceWidth(context) / 2 - 5,
                    child: ImageViewNetwork(
                      url:
                          'https://i.pinimg.com/originals/38/d7/5b/38d75b985d9d08ce0959201f8198f405.jpg',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ptPrimaryColor(context),
                    ),
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      MdiIcons.thumbUp,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '12',
                    style: ptSmall(),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      showComment();
                    },
                    child: Text(
                      '1 comments',
                      style: ptSmall(),
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.thumbUpOutline,
                          size: 19,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Like',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ]),
                ),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.commentOutline,
                          color: Colors.black54,
                          size: 19,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            showComment();
                          },
                          child: Text(
                            'Comment',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.shareOutline,
                          color: Colors.black54,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () => shareTo(context),
                          child: Text(
                            'Share',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ]),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showComment() {
    showModalBottomSheet(
        useRootNavigator: true,
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
              height: deviceHeight(context) - kToolbarHeight - 15,
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: deviceWidth(context),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 4,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: CommentPage()),
                ],
              ));
        });
  }
}
