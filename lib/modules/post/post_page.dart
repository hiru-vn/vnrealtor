import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/inbox/inbox_list.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/modules/post/suggest_list.dart';
import 'package:datcao/modules/profile/recomend_dialog.dart';
import 'package:datcao/share/widget/empty_widget.dart';
import 'package:datcao/share/widget/load_more.dart';
import 'package:flutter/rendering.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/create/create_post_page.dart';
import 'package:datcao/modules/post/search/search_post_page.dart';
import 'package:datcao/share/import.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'post_widget.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool showAppBar = true;
  PostBloc? _postBloc;
  late AuthBloc _authBloc;
  bool isFilterDistance = false;
  int distance = 20;
  // ScrollController _postBloc.feedScrollController = ScrollController();
  // PageController _postBloc.pageController = PageController();

  @override
  void initState() {
    // _postBloc.feedScrollController.addListener(appBarControll);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _authBloc = Provider.of<AuthBloc>(context);
      Future.delayed(Duration(seconds: 5), () => _showRecomendDialog(context));
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _postBloc.feedScrollController.removeListener(appBarControll);
    super.dispose();
  }

  void appBarControll() {
    if (_postBloc!.feedScrollController.position.userScrollDirection ==
            ScrollDirection.forward ||
        _postBloc!.feedScrollController.offset == 0) {
      if (!showAppBar)
        setState(() {
          showAppBar = !showAppBar;
        });
    } else {
      if (showAppBar) if (_postBloc!.feedScrollController.offset >
          kToolbarHeight)
        setState(() {
          showAppBar = !showAppBar;
        });
    }
  }

  _getPostLocal() async {
    final res = await _postBloc!.getPostLocal(distance.toDouble());
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _postBloc!.pageController = PageController();
    _postBloc!.feedScrollController = ScrollController();
    return PageView(
        controller: _postBloc!.pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Scaffold(
            backgroundColor: ptBackgroundColor(context),
            appBar: showAppBar
                ? PostPageAppBar(_authBloc.userModel!.messNotiCount ?? 0)
                : null,
            body: LoadMoreScrollView(
              scrollController: _postBloc!.feedScrollController,
              onLoadMore: () {
                _postBloc!.loadMoreNewFeed();
              },
              list: RefreshIndicator(
                color: ptPrimaryColor(context),
                onRefresh: () async {audioCache.play('tab3.mp3');
                  setState(() {
                    isFilterDistance = false;
                  });
                  await Future.wait([
                    _postBloc!.getNewFeed(
                        filter:
                            GraphqlFilter(limit: 10, order: "{updatedAt: -1}")),
                    _postBloc!.getStoryFollowing()
                  ]);

                  return;
                },
                child: InViewNotifierCustomScrollView(
                    // physics: const BouncingScrollPhysics(
                    //     parent: AlwaysScrollableScrollPhysics()),
                    isInViewPortCondition: (double deltaTop, double deltaBottom,
                        double viewPortDimension) {
                      return deltaTop < (0.5 * viewPortDimension) + 100.0 &&
                          deltaBottom > (0.5 * viewPortDimension) - 100.0;
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _postBloc!.feedScrollController,
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: (!showAppBar)
                                ? MediaQuery.of(context).padding.top +
                                    kToolbarHeight
                                : 0,
                          ),
                          CreatePostCard(
                            postBloc: _postBloc,
                            pageController: _postBloc!.pageController,
                          ),
                          if (_postBloc!.isReloadFeed) PostSkeleton(),
                          if (_postBloc!.hasTags != null &&
                              _postBloc!.hasTags!.length > 0)
                            Container(
                              width: deviceWidth(context),
                              height: 30,
                              margin: EdgeInsets.only(top: 8),
                              // padding: EdgeInsets.symmetric(horizontal: 20),
                              child: ListView.separated(
                                // shrinkWrap: true,
                                padding: EdgeInsets.only(left: 15),
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  if (index == 0) {
                                    return PopupMenuButton(
                                      itemBuilder: (_) => <PopupMenuItem<int>>[
                                        PopupMenuItem(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Bán kính 10 km'),
                                              if (distance == 10)
                                                Icon(Icons.check, size: 18)
                                            ],
                                          ),
                                          value: 10,
                                        ),
                                        PopupMenuItem(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Bán kính 20 km'),
                                                if (distance == 20)
                                                  Icon(Icons.check, size: 18)
                                              ],
                                            ),
                                            value: 20),
                                        PopupMenuItem(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Bán kính 50 km'),
                                                if (distance == 50)
                                                  Icon(Icons.check, size: 18)
                                              ],
                                            ),
                                            value: 50),
                                      ],
                                      onSelected: (dynamic val) async {
                                        setState(() {
                                          isFilterDistance = true;
                                          distance = val;
                                        });
                                        _getPostLocal();
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Center(
                                        child: Icon(Icons.my_location,
                                            color: !isFilterDistance
                                                ? Colors.black54
                                                : ptPrimaryColor(context)),
                                      ),
                                    );
                                  }
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      SearchPostPage.navigate(
                                          hashTag: _postBloc!.hasTags![index - 1]
                                              ['value']);
                                    },
                                    child: Container(
                                      height: 30,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: ptSecondaryColor(context),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Center(
                                        child: Text(
                                          _postBloc!.hasTags![index - 1]['value']
                                              .toString(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: _postBloc!.hasTags!.length,
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          _postBloc!.feed!.length == 0
                              ? EmptyWidget(
                                  assetImg: 'assets/image/no_post.png',
                                  title: 'Không tìm thấy bài đăng',
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _postBloc!.feed!.length,
                                  itemBuilder: (context, index) {
                                    final item = _postBloc!.feed![index];
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (index ==
                                                (AuthBloc.firstLogin ? 0 : 5) &&
                                            UserBloc.instance
                                                    .suggestFollowUsers !=
                                                null &&
                                            UserBloc.instance.suggestFollowUsers
                                                    .length >
                                                0)
                                          SuggestListUser(
                                            users: UserBloc
                                                .instance.suggestFollowUsers,
                                          ),
                                        PostWidget(item),
                                      ],
                                    );
                                  },
                                ),
                          if (_postBloc!.isLoadMoreFeed && !_postBloc!.isEndFeed)
                            PostSkeleton(
                              count: 1,
                            ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ))
                    ]),
              ),
            ),
          ),
          CreatePostPage(_postBloc!.pageController)
        ]);
  }
}

Future<bool?> _showRecomendDialog(BuildContext context) async {
  final notShowRecomendAgain =
      await SPref.instance.getBool('notShowRecomendAgain');
  if (notShowRecomendAgain) return Future.value(false);
  if (AuthBloc.firstLogin) return Future.value(false);
  if (PostBloc.instance.myPosts!
          .where((element) =>
              DateTime.tryParse(element.createdAt!)!
                  .compareTo(DateTime.now().subtract(Duration(days: 1))) >=
              0)
          .length ==
      0) return Future.value(false);
  if (AuthBloc.instance.userModel!.role != 'EDITOR') return Future.value(false);

  return showDialog<bool>(
      context: context,
      builder: (context) {
        return FunkyOverlay();
      });
}

class CreatePostCard extends StatelessWidget {
  final PostBloc? postBloc;
  final PageController? pageController;

  const CreatePostCard({Key? key, this.postBloc, this.pageController})
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
                  audioCache.play('tab3.mp3');
                  pageController!
                      .animateToPage(1,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.decelerate)
                      .then((value) => null);
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
                          onTap: () {audioCache.play('tab3.mp3');
                            pageController!.animateToPage(1,
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
                          onTap: () {audioCache.play('tab3.mp3');
                            pageController!.animateToPage(1,
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
            if ((postBloc?.stories.length ?? 0) > 0 || postBloc!.isLoadStory)
              Divider(
                height: 10,
              ),
            postBloc!.isLoadStory
                ? StorySkeleton()
                : postBloc!.stories.length == 0
                    ? SizedBox.shrink()
                    : SizedBox(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            itemCount: postBloc!.stories.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              return buildStoryWidget(postBloc!.stories[index]);
                            }),
                      ),
          ],
        ),
      ),
    );
  }
}

buildStoryWidget(PostModel postModel) {
  return Center(
    child: GestureDetector(
      onTap: () {audioCache.play('tab3.mp3');
        PostDetail.navigate(postModel);
      },
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 144,
          width: 109,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(postModel.storyImages?[0] ??
                      postModel.mediaPosts![0].halfUrl!))),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 1.5, color: Colors.white),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                        backgroundImage: postModel.isPage!
                            ? (postModel.page!.avartar != null &&
                                    postModel.page!.avartar != 'null'
                                ? CachedNetworkImageProvider(
                                    postModel.page!.avartar!)
                                : AssetImage('assets/image/default_avatar.png')) as ImageProvider<Object>?
                            : (postModel.user!.avatar != null &&
                                    postModel.user!.avatar != 'null'
                                ? CachedNetworkImageProvider(
                                    postModel.user!.avatar!)
                                : AssetImage('assets/image/default_avatar.png')) as ImageProvider<Object>?,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Expanded(
                    child: Text(
                      postModel.isPage!
                          ? postModel.page!.name!
                          : postModel.user!.name ?? '',
                      overflow: TextOverflow.fade,
                      style: ptTiny().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            if (postModel.district != null && postModel.district!.trim() != "")
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_pin, size: 14.5),
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 84),
                          child: Text(
                            postModel.district!,
                            style: ptTiny().copyWith(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

class PostPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  final int unReadCount;
  PostPageAppBar(this.unReadCount);
  @override
  Widget build(BuildContext context) {
    final count = unReadCount > 9 ? '9+' : unReadCount.toString();
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 15, top: 12, bottom: 10, right: 12),
            child: Image.asset('assets/image/logo_full.png'),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 10),
            child: GestureDetector(
              onTap: () {audioCache.play('tab3.mp3');
                SearchPostPage.navigate().then((value) =>
                    FocusScope.of(context).requestFocus(FocusNode()));
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
          ),
          GestureDetector(
            onTap: () {audioCache.play('tab3.mp3');
              AuthBloc.instance.userModel!.messNotiCount = 0;
              UserBloc.instance.seenNotiMess();
              InboxList.navigate();
            },
            child: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12, bottom: 10, right: 12),
                  child: Container(
                      width: 42,
                      height: 42,
                      child: Icon(
                        MdiIcons.chatProcessing,
                        size: 26,
                      )),
                ),
                if (unReadCount > 0)
                  Positioned(
                    top: 9,
                    right: 11,
                    child: Container(
                      padding: EdgeInsets.all(count.length == 2 ? 3.5 : 5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(count,
                          style: ptTiny().copyWith(
                              fontSize: 10.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
      color: ptSecondaryColor(context),
    );
  }
}
