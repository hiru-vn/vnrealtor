import 'package:flutter/rendering.dart';
import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/post/create_post_page.dart';
import 'package:vnrealtor/modules/post/search_post_page.dart';
import 'package:vnrealtor/share/import.dart';

import 'post_widget.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool showAppBar = true;
  PostBloc _postBloc;
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(appBarControll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of(context);
      _postBloc.getNewFeed(
          filter: GraphqlFilter(limit: 20, order: "{createdAt: -1}"));
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.removeListener(appBarControll);
    super.dispose();
  }

  void appBarControll() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      if (!showAppBar)
        setState(() {
          showAppBar = !showAppBar;
        });
    } else {
      if (showAppBar) if (_controller.offset > kToolbarHeight + 10)
        setState(() {
          showAppBar = !showAppBar;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: showAppBar ? PostPageAppBar() : null,
      body: RefreshIndicator(
        color: ptPrimaryColor(context),
        onRefresh: () async {
          await _postBloc.getNewFeed(
              filter: GraphqlFilter(limit: 20, order: "{createdAt: -1}"));
          return;
        },
        child: SingleChildScrollView(
          controller: _controller,
          child: Column(
            children: [
              SizedBox(
                height: (!showAppBar)
                    ? MediaQuery.of(context).padding.top + kToolbarHeight + 10
                    : 0,
              ),
              CreatePostCard(),
              ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _postBloc.post.length,
                itemBuilder: (context, index) {
                  final item = _postBloc.post[index];
                  return PostWidget(item);
                },
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreatePostCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      child: Container(
        width: deviceWidth(context),
        padding: EdgeInsets.symmetric(vertical: 15),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  CreatePostPage.navigate();
                },
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 13),
                    child: Row(
                      children: [
                        Text(
                          'Đăng tin của bạn',
                          style: ptTitle(),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            CreatePostPage.navigate();
                          },
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.location_pin,
                              size: 21,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            CreatePostPage.navigate();
                          },
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              MdiIcons.image,
                              size: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 6,
                  ),
                  Image.asset('assets/image/map_icon.png'),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Bài viết nổi bật',
                    style: ptBody().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 170,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                SizedBox(width: 20),
                _buildStoryWidget(),
                SizedBox(width: 15),
                _buildStoryWidget(),
                SizedBox(width: 15),
                _buildStoryWidget(),
                SizedBox(width: 20),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _buildStoryWidget() {
    return Center(
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 154,
          width: 119,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      'https://media.ex-cdn.com/EXP/media.nhadautu.vn/files/ducson/2017/08/09/bds-nha-trang-1143.jpg'))),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5, color: Colors.white),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 13,
                        backgroundImage: AssetImage('assets/image/avatar.jpeg'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      'Hoài Linh',
                      style: ptTiny().copyWith(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_pin, size: 16),
                  SizedBox(width: 1),
                  Text(
                    'Hồ Chí Minh',
                    style: ptTiny(),
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class PostPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  PostPageAppBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, top: 12, bottom: 10, right: 12),
        child: Row(
          children: [
            Image.asset('assets/image/logo_full.png'),
            Spacer(),
            GestureDetector(
              onTap: () {
                SearchPostPage.navigate();
              },
              child: SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.search,
                  size: 26,
                ),
              ),
            ),
            SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  MdiIcons.chatProcessing,
                  size: 26,
                ))
          ],
        ),
      ),
      color: ptSecondaryColor(context),
    );
  }
}
