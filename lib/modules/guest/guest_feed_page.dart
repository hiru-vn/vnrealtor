import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/post/post_page.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/widget/load_more.dart';
import 'package:flutter/rendering.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
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
  List<PostModel> stories;
  bool isReloadPost = true;
  bool isReloadStory = true;

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
              isReloadPost = false;
            } else {
              showToast(res.errMessage, context);
              posts = [];
              isReloadPost = false;
            }
          }));
      _postBloc.getStoryForGuest().then((res) => setState(() {
            if (res.isSuccess) {
              stories = res.data;
              isReloadStory = false;
            } else {
              showToast(res.errMessage, context);
              posts = [];
              isReloadStory = false;
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
      if (showAppBar) if (_controller.offset > kToolbarHeight)
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
          showToast('Vui lòng đăng nhập để tiếp tục xem', context,
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
                      ? MediaQuery.of(context).padding.top + kToolbarHeight
                      : 0,
                ),
                CreatePostCardGuest(
                  postBloc: _postBloc,
                  pageController: _postBloc.pageController,
                  stories: stories,
                ),
                if (posts == null)
                  PostSkeleton()
                else
                  ListView.builder(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final item = posts[index];
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
      ),
    );
  }
}

class CreatePostCardGuest extends StatelessWidget {
  final PostBloc postBloc;
  final PageController pageController;
  final List<PostModel> stories;

  const CreatePostCardGuest(
      {Key key, this.postBloc, this.pageController, this.stories})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      //elevation: 5,
      child: Container(
        width: deviceWidth(context),
        padding: EdgeInsets.symmetric(vertical: 8),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: GestureDetector(
                onTap: () {
                  if (AuthBloc.instance.userModel == null) {
                    LoginPage.navigatePush();
                    return;
                  }
                  pageController.animateToPage(1,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.decelerate);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(0),
                  //elevation: 5,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      children: [
                        Text(
                          'Đăng tin của bạn',
                          style: ptTitle(),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (AuthBloc.instance.userModel == null) {
                              LoginPage.navigatePush();
                              return;
                            }
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
                            if (AuthBloc.instance.userModel == null) {
                              LoginPage.navigatePush();
                              return;
                            }
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
            if (stories == null ||
                (stories?.length ?? 0) > 0 ||
                AuthBloc.instance.userModel == null)
              Divider(
                height: 10,
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
            stories == null
                ? StorySkeleton()
                : stories.length == 0
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            itemCount: stories.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return buildStoryWidget(stories[index]);
                            }),
                      ),
          ],
        ),
      ),
    );
  }
}

class GuestFeedPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
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
