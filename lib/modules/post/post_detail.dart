import 'dart:math';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/address.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/model/valuation.dart';
import 'package:datcao/modules/post/comment_page.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/modules/model/reply.dart';
import 'package:datcao/share/import.dart';
import 'dart:async';
import 'package:datcao/share/widget/tag_user_field.dart';

class PostDetail extends StatefulWidget {
  final PostModel? postModel;
  final String? postId;

  const PostDetail({Key? key, this.postModel, this.postId}) : super(key: key);
  static Future navigate(PostModel? postModel, {String? postId}) {
    return navigatorKey.currentState!.push(pageBuilder(PostDetail(
      postModel: postModel,
      postId: postId,
    )));
  }

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail>
    with SingleTickerProviderStateMixin {
  List<CommentModel>? comments;
  TextEditingController _commentC = TextEditingController();
  PostBloc? _postBloc;
  PostModel? _post;
  Address? _address;
  // StreamSubscription<FetchResult> _streamSubcription;
  bool isReply = false;
  FocusNode _focusNodeComment = FocusNode();
  CommentModel? replyComment;
  List<ReplyModel?> localReplies = [];
  List<UserModel> tagUsers = [];
  TabController? _tabController;
  List<ValuationHcmStreet> values = [];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _focusNodeComment.addListener(() {
      if (!_focusNodeComment.hasFocus) {
        // setState(() {
        //   isReply = false;
        //   replyComment = null;
        // });
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);

      if (widget.postModel != null) {
        _post = widget.postModel;
        _getComments(_post!.id, filter: GraphqlFilter(limit: 20));
        _getAddress();
      } else {
        _getPost().then((value) {
          _getValuation();
          _getAddress();
        });
        _getComments(widget.postId, filter: GraphqlFilter(limit: 20));
      }

      //setup socket
      // _postBloc.subscriptionCommentByPostId(widget.postModel?.id??widget.postId);

      // Future.delayed(Duration(seconds: 2), () {
      //   _streamSubcription = _postBloc.commentSubcription.listen((event) {
      //     print(event.data);
      //     CommentModel socketComment =
      //         CommentModel.fromJson(event.data['newComment']);
      //     if (socketComment.userId != AuthBloc.instance.userModel?.id)
      //       setState(() {
      //         comments.add(socketComment);
      //       });
      //   });
      // });
    }
    super.didChangeDependencies();
  }

  _getAddress() async {
    final address =
        await _postBloc!.getAddress(_post!.locationLong!, _post!.locationLat!);
    setState(() {
      _address = address.data as Address;
    });
    _getValuation();
  }

  _getValuation() async {
    final res = await _postBloc!.getValuation(id: _post!.valuationHcmId);
    setState(() {
      values = [res.data];
    });
  }

  _deleteComment(String? id) async {
    comments!.removeWhere((element) => element.id == id);
    setState(() {});
    final res = await _postBloc!.deleteComment(id);
    if (!res.isSuccess) showToast(res.errMessage, context);
  }

  _reply(String text) async {
    if (text.trim() == '') return;
    if (replyComment == null) return;
    text = text.trim();
    if (comments == null) await Future.delayed(Duration(seconds: 1));
    _commentC.clear();
    localReplies.add(ReplyModel(
        content: text,
        userId: AuthBloc.instance.userModel!.uid,
        commentId: replyComment!.id,
        user: AuthBloc.instance.userModel,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        userTags: Map.fromIterable(tagUsers,
            key: (e) => e.id, value: (e) => e.name)));
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc!.createReply(text, replyComment!.id,
        tagUserIds: tagUsers.map((e) => e.id).toList());
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      final index = localReplies
          .indexWhere((element) => element!.createdAt == res.data.createdAt);
      if (index >= 0) {
        localReplies[index] = res.data;
      }
      comments!
          .firstWhere((element) => element.id == replyComment!.id)
          .replyIds!
          .add(localReplies[index]!.id);

      if (mounted)
        setState(() {
          isReply = false;
          replyComment = null;
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _streamSubcription?.cancel();
  }

  Future _getPost() async {
    var res;
    if (AuthBloc.instance.userModel != null) {
      res = await _postBloc!.getOnePost(widget.postId);
    } else {
      res = await _postBloc!.getOnePostGuest(widget.postId);
    }
    if (res.isSuccess) {
      setState(() {
        _post = res.data;
      });
    } else {
      navigatorKey.currentState!.maybePop();
      showToast(res.errMessage, context);
    }
  }

  Future _getComments(String? postId, {GraphqlFilter? filter}) async {
    BaseResponse res = AuthBloc.instance.userModel != null
        ? await _postBloc!.getAllCommentByPostId(postId, filter: filter)
        : await _postBloc!.getAllCommentByPostIdGuest(postId, filter: filter);
    if (res == null) return;
    if (res.isSuccess) {
      if (mounted)
        setState(() {
          comments = res.data;
        });
    } else {
      showToast('Có lỗi khi lấy dữ liệu', context);
    }
  }

  _comment(String text) async {
    if (text.trim() == '') return;
    text = text.trim();
    if (comments == null) await Future.delayed(Duration(seconds: 1));
    _commentC.clear();
    comments!.add(
      CommentModel(
          content: text,
          like: 0,
          userId: AuthBloc.instance.userModel!.id,
          user: AuthBloc.instance.userModel,
          updatedAt: DateTime.now().toIso8601String(),
          userTags: Map.fromIterable(tagUsers,
              key: (e) => e.id, value: (e) => e.name)),
    );
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc!.createComment(text,
        postId: _post?.id, tagUserIds: tagUsers.map((e) => e.id).toList());
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      final resComment = (res.data as CommentModel);
      _post!.commentIds!.add(resComment.id);
      final index = comments!
          .lastIndexWhere((element) => element.userId == resComment.userId);
      if (index >= 0)
        setState(() {
          comments![index] = resComment;
          tagUsers = [];
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    double? ratio;
    int index = 0;
    if (values.length > 0) {
      ratio = (_post?.price ?? 1) /
          ((values[index].avgPrice?.toDouble() ?? 1) * (_post?.area ?? 0));
    }
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: _post != null
            ? 'Bài viết của ${_post!.isPage! ? _post!.page!.name : _post!.user!.name}'
            : '',
        automaticallyImplyLeading: true,
        bgColor: ptSecondaryColor(context),
        textColor: ptPrimaryColor(context),
      ),
      body: Stack(
        children: [
          Container(
            height: deviceHeight(context),
            width: deviceWidth(context),
          ),
          NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: _post == null
                      ? PostSkeleton(
                          count: 1,
                        )
                      : PostWidget(_post,
                          commentCallBack: () {}, isInDetailPage: true),
                ),
              ];
            },
            body: Column(
              children: [
                Center(
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 1,
                      indicatorColor: ptPrimaryColor(context),
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.black87,
                      unselectedLabelStyle: ptTitle(),
                      labelStyle: ptTitle(),
                      tabs: [
                        SizedBox(
                          height: 35,
                          width: deviceWidth(context) / 2 - 60,
                          child: Tab(
                            child: Text('Bình luận'),
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          width: deviceWidth(context) / 2 - 60,
                          child: Tab(
                            child: Text('Thông tin'),
                          ),
                        ),
                      ]),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      comments != null
                          ? ListView.separated(
                              padding: EdgeInsets.only(
                                  bottom: AuthBloc.instance.userModel == null
                                      ? 20
                                      : 0),
                              itemCount: comments!.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final comment = comments![index];
                                return CommentWidget(
                                    comment: comment,
                                    userReplyCache: localReplies,
                                    shouldExpand:
                                        comments![index].id == replyComment?.id,
                                    deleteCallBack: comments![index].userId ==
                                            AuthBloc.instance.userModel?.id
                                        ? () =>
                                            _deleteComment(comments![index].id)
                                        : () {},
                                    tapCallBack: () {
                                      setState(() {
                                        isReply = true;
                                        replyComment = comments![index];
                                      });
                                      _focusNodeComment.requestFocus();
                                    });
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox.shrink(),
                            )
                          : ListSkeleton(),
                      SingleChildScrollView(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                child: Column(
                                  children: [
                                    _buildTextInfo('Diện tích: ',
                                        '${_post?.area?.round().toString()} m2'),
                                    SpacingBox(h: 2.5),
                                    _buildTextInfo(
                                        'Phân loại: ', '${_post?.category}'),
                                    SpacingBox(h: 2.5),
                                    _buildTextInfo(
                                        'Nhu cầu: ', '${_post?.action}'),
                                    SpacingBox(h: 2.5),
                                    _buildTextInfo('Giá người đăng đưa ra: ',
                                        '${Formart.toVNDPrice(_post?.price?.toDouble() ?? 0)}'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                child: Column(
                                  children: [
                                    _buildTextInfo('Địa chỉ trên toạ độ: ',
                                        '${_address?.address}'),
                                    if (values.length > 0) ...[
                                      SpacingBox(h: 2.5),
                                      _buildTextInfo(
                                          'Giá thẩm định T${DateTime.now().month}: ',
                                          '${Formart.toVNDPrice(values[index].avgPrice?.toDouble() ?? 0)}/ m2 (${values[index].priceChangedPercentage}%)'),
                                      SpacingBox(h: 2.5),
                                      _buildTextInfo(
                                          'Giá thẩm định T${DateTime.now().subtract(Duration(days: 31)).month}: ',
                                          '${Formart.toVNDPrice(values[index].prevAvgPrice?.toDouble() ?? 0)}/ m2'),
                                      SpacingBox(h: 2.5),
                                      if (ratio == null)
                                        Container()
                                      else if (ratio < 0.6)
                                        Text(
                                          "Người bán đưa ra giá tương đương ${(ratio * 100).toStringAsFixed(2)}% so với trung bình. Số liệu này có vẻ không chính xác với thực tế",
                                          style: ptBody()
                                              .copyWith(color: Colors.black),
                                        )
                                      else if (0.6 <= ratio && ratio < 0.95)
                                        Text(
                                          "Người bán đưa ra giá tương đương ${(ratio * 100).round()}% so với trung bình. Đây có vẻ là 1 sự đầu tư đúng đắn.",
                                          style: ptBody()
                                              .copyWith(color: Colors.black),
                                        )
                                      else if (0.95 <= ratio && ratio < 1.1)
                                        Text(
                                          "Người bán đưa ra giá tương đương ${(ratio * 100).round()}% so với trung bình.",
                                          style: ptBody()
                                              .copyWith(color: Colors.black),
                                        ),
                                      SpacingBox(h: 2.5),
                                      Text(
                                        'Giá thẩm định là giá được chúng tôi khảo sát được trên trang website mogi.vn, giá chỉ mang tính chất tham khảo cung cấp thông tin cho người mua.',
                                        style: ptTiny().copyWith(
                                          color: Colors.red,
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                              ),
                              SpacingBox(h: 2.5),
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  'Bài đăng gần đó',
                                  style: ptTitle(),
                                ),
                              ),
                              ListView.separated(
                                // controller: _userBloc.profileScrollController,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.only(bottom: 20),
                                itemCount: _postBloc!.savePosts.length,
                                itemBuilder: (context, index) {
                                  final post = _postBloc!.savePosts[index];
                                  return PostSmallWidget(post);
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 0),
                              ),
                              SpacingBox(h: 12.5),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (AuthBloc.instance.userModel != null)
            Positioned(
              bottom: 0,
              child: Container(
                width: deviceWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                color: Colors.white,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white,
                      backgroundImage: (AuthBloc.instance.userModel?.avatar !=
                                  null
                              ? CachedNetworkImageProvider(
                                  AuthBloc.instance.userModel!.avatar!)
                              : AssetImage('assets/image/default_avatar.png'))
                          as ImageProvider<Object>?,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: TagUserField(
                        onUpdateTags: (users) {
                          tagUsers = users;
                        },
                        controller: _commentC,
                        focusNode: _focusNodeComment,
                        keyboardPadding:
                            MediaQuery.of(context).viewInsets.bottom,
                        onTap: () {
                          if (AuthBloc.instance.userModel == null) {
                            LoginPage.navigatePush();
                            return;
                          }
                        },
                        // maxLength: 200,
                        onSubmitted: _comment,
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                audioCache.play('tab3.mp3');
                                (isReply)
                                    ? _reply(_commentC.text)
                                    : _comment(_commentC.text);
                              },
                              child: Container(
                                  height: 35,
                                  width: 35,
                                  child: Center(child: Icon(Icons.send)))),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                          isDense: true,
                          hintText: isReply
                              ? 'Trả lời ${replyComment?.user?.name ?? ''}'
                              : 'Viết bình luận.',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          fillColor: ptSecondaryColor(context),
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  _buildTextInfo(String title, String content) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
          ),
        ),
        Expanded(
          child: Text(content),
        )
      ],
    );
  }
}
