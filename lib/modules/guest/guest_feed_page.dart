import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/widget/load_more.dart';
import 'package:flutter/rendering.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/share/import.dart';

class GuestFeedPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState
        .pushReplacement(pageBuilder(GuestFeedPage()));
  }

  @override
  _GuestFeedPageState createState() => _GuestFeedPageState();
}

class _GuestFeedPageState extends State<GuestFeedPage> {
  bool showAppBar = true;
  PostBloc _postBloc;
  ScrollController _controller = ScrollController();
  List<PostModel> posts;
  bool isReload = true;

  @override
  void initState() {
    _controller.addListener(appBarControll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _postBloc.getNewFeedGuest().then((res) => setState(() {
            if (res.isSuccess) {
              posts = res.data;
              isReload = false;
            } else {
              showToast(res.errMessage, context);
              posts = [];
              isReload = false;
            }
          }));
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
      appBar: showAppBar ? GuestFeedPageAppBar() : null,
      body: LoadMoreScrollView(
        scrollController: _controller,
        onLoadMore: () {
          showToast('Xin hãy đăng nhập để tiếp tục xem', context,
              isSuccess: true);
        },
        list: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            final res = await _postBloc.getNewFeedGuest();
            if (res.isSuccess) {
              setState(() {
                posts = res.data;
              });
            } else {
              showToast(res.errMessage, context);
            }
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
                AbsorbPointer(
                  child: CreatePostCard(
                    postBloc: _postBloc,
                    pageController: _postBloc.pageController,
                  ),
                ),
                if (posts == null) PostSkeleton(),
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
                if (_postBloc.isLoadMoreFeed && !_postBloc.isEndFeed)
                  PostSkeleton(
                    count: 2,
                  ),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePostCard extends StatelessWidget {
  final PostBloc postBloc;
  final PageController pageController;

  const CreatePostCard({Key key, this.postBloc, this.pageController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      //elevation: 5,
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
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(0),
                  //elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 17, vertical: 11),
                    child: Row(
                      children: [
                        Text(
                          'Đăng tin của bạn',
                          style: ptTitle(),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate);
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
                            pageController.animateToPage(1,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate);
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
            if ((postBloc.stories?.length ?? 0) > 0 || postBloc.isLoadStory)
              Divider(
                height: 22,
              ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 20,
            //   ),
            //   child: Row(
            //     children: [
            //       SizedBox(
            //         width: 6,
            //       ),
            //       Image.asset('assets/image/map_icon.png'),
            //       SizedBox(
            //         width: 6,
            //       ),
            //       Text(
            //         // 'Bài viết nổi bật',
            //         '',
            //         style: ptBody().copyWith(
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            postBloc.isLoadStory
                ? StorySkeleton()
                : postBloc.stories.length == 0
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 170,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: postBloc.stories.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 15),
                            itemBuilder: (context, index) {
                              return _buildStoryWidget(postBloc.stories[index]);
                            }),
                      ),
          ],
        ),
      ),
    );
  }

  _buildStoryWidget(PostModel postModel) {
    return Center(
      child: GestureDetector(
        onTap: () {
          PostDetail.navigate(postModel);
        },
        child: Material(
          elevation: 0,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 154,
            width: 119,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(postModel.mediaPosts[0].url))),
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
                          backgroundColor: Colors.white,
                          backgroundImage: postModel.user.avatar != null
                              ? NetworkImage(postModel.user.avatar)
                              : AssetImage('assets/image/default_avatar.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Text(
                        postModel.user.name,
                        overflow: TextOverflow.fade,
                        style: ptTiny().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              if (postModel.district != null && postModel.district.trim() != "")
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_pin, size: 16),
                      SizedBox(width: 1),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 95),
                        child: Text(
                          postModel.district,
                          style: ptTiny(),
                        ),
                      ),
                    ],
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}

class GuestFeedPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 10);
  GuestFeedPageAppBar();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 15, top: 12, bottom: 10, right: 12),
        child: Row(
          children: [
            Image.asset('assets/image/logo_full.png'),
            Spacer(),
            FlatButton(
                color: ptPrimaryColor(context),
                onPressed: () {
                  LoginPage.navigatePush();
                },
                child: Text(
                  'Đăng nhập',
                  style: ptTitle().copyWith(color: Colors.white),
                )),
          ],
        ),
      ),
      color: ptSecondaryColor(context),
    );
  }
}
