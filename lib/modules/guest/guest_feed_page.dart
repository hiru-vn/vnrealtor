import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/post_page.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/modules/post/search_post_page.dart';
import 'package:datcao/modules/post/suggest_list.dart';
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
  UserBloc _userBloc;
  ScrollController _controller = ScrollController();
  List<PostModel> posts;
  List<PostModel> stories;
  List<UserModel> suggestFollowUsers;
  bool isReloadPost = true;
  bool isReloadStory = true;
  int page = 1;

  @override
  void initState() {
    _controller.addListener(appBarControll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _userBloc = Provider.of<UserBloc>(context);
      _postBloc.getNewFeedGuest(1).then((res) => setState(() {
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
      _userBloc.suggestFollowGuest().then((res) => setState(() {
            if (res.isSuccess) {
              setState(() {
                suggestFollowUsers = res.data;
              });
            } else {
              showToast(res.errMessage, context);
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
    return Container(
      color: ptPrimaryColor(context),
      child: Scaffold(
        backgroundColor: ptBackgroundColor(context),
        appBar: showAppBar ? GuestFeedPageAppBar() : null,
        body: LoadMoreScrollView(
          scrollController: _controller,
          onLoadMore: () async {
            final res = await _postBloc.getNewFeedGuest(page + 1);
            if (res.isSuccess) {
              setState(() {
                page++;
                posts.addAll(res.data);
              });
            } else {
              showToast(res.errMessage, context);
            }
            return;
          },
          list: RefreshIndicator(
            color: ptPrimaryColor(context),
            onRefresh: () async {
              audioCache.play('tab3.mp3');
              final res = await _postBloc.getNewFeedGuest(1);
              if (res.isSuccess) {
                setState(() {
                  page = 1;
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
                  // if (_postBloc.hasTags != null && _postBloc.hasTags.length > 0)
                  //   Container(
                  //     width: deviceWidth(context),
                  //     height: 30,
                  //     margin: EdgeInsets.only(top: 8),
                  //     // padding: EdgeInsets.symmetric(horizontal: 20),
                  //     child: ListView.separated(
                  //       // shrinkWrap: true,
                  //       padding: EdgeInsets.only(left: 15),
                  //       separatorBuilder: (context, index) {
                  //         return SizedBox(
                  //           width: 10,
                  //         );
                  //       },
                  //       itemBuilder: (context, index) {
                  //         return InkWell(
                  //           borderRadius: BorderRadius.circular(15),
                  //           onTap: () {
                  //             SearchPostPage.navigate(
                  //                 hashTag: _postBloc.hasTags[index]['value']);
                  //           },
                  //           child: Container(
                  //             height: 30,
                  //             padding: EdgeInsets.symmetric(horizontal: 10),
                  //             decoration: BoxDecoration(
                  //                 color: ptSecondaryColor(context),
                  //                 borderRadius: BorderRadius.circular(15)),
                  //             child: Center(
                  //               child: Text(
                  //                 _postBloc.hasTags[index]['value'].toString(),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //       itemCount: _postBloc.hasTags.length,
                  //       scrollDirection: Axis.horizontal,
                  //     ),
                  //   ),
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
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PostWidget(item),
                            if (index == 1 &&
                                suggestFollowUsers != null &&
                                suggestFollowUsers.length > 0)
                              SuggestListUser(
                                users: suggestFollowUsers,
                              ),
                          ],
                        );
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
        color: ptPrimaryColor(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: GestureDetector(
                onTap: () {
                  audioCache.play('tab3.mp3');
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
                            audioCache.play('tab3.mp3');
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
                            audioCache.play('tab3.mp3');
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
                        height: 85,
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
    return AppBar(
      brightness: Theme.of(context).brightness,
      title: Row(
        children: [
          Image.asset(
            'assets/image/logo_datcao.png',
            width: 40,
          ),
          Spacer(),
          ExpandBtn(
              text: "Đăng nhập",
              width: 100,
              onPress: () {
                audioCache.play('tab3.mp3');
                LoginPage.navigatePush();
              }),
        ],
      ),
    );
  }
}
