import 'package:flutter/rendering.dart';
import 'package:vnrealtor/modules/authentication/auth_bloc.dart';
import 'package:vnrealtor/modules/bloc/post_bloc.dart';
import 'package:vnrealtor/modules/model/comment.dart';
import 'package:vnrealtor/modules/model/media_post.dart';
import 'package:vnrealtor/modules/model/post.dart';
import 'package:vnrealtor/share/import.dart';

class CommentPage extends StatefulWidget {
  final PostModel post;
  final MediaPost mediaPost;

  const CommentPage({Key key, this.post, this.mediaPost}) : super(key: key);

  static Future navigate(PostModel post, MediaPost mediaPost) {
    return navigatorKey.currentState.push(pageBuilder(CommentPage(
      post: post,
      mediaPost: mediaPost,
    )));
  }

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  bool isPost = true;
  bool isMediaPost = false;
  List<CommentModel> comments;
  TextEditingController _commentC = TextEditingController();
  PostBloc _postBloc;
  String sort = '{createdAt: 1}';

  @override
  void initState() {
    if (widget.mediaPost != null) {
      isPost = false;
      isMediaPost = true;
    }

    super.initState();
  }

  _comment(String text) async {
    text = text.trim();
    if (comments == null) await Future.delayed(Duration(seconds: 1));
    _commentC.clear();
    comments.add(CommentModel(
        content: text,
        like: 0,
        user: AuthBloc.instance.userModel,
        updatedAt: DateTime.now().toIso8601String()));
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc.createComment(text,
        postId: widget.post?.id, mediaPostId: widget.mediaPost?.id);
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      if (isPost) widget.post.commentIds.add((res.data as CommentModel).id);
      if (isMediaPost)
        widget.mediaPost.commentIds.add((res.data as CommentModel).id);
    }
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _getComments(filter: GraphqlFilter(limit: 20));
    }
    super.didChangeDependencies();
  }

  Future _getComments({GraphqlFilter filter}) async {
    BaseResponse res;
    if (isPost)
      res =
          await _postBloc.getAllCommentByPostId(widget.post.id, filter: filter);
    if (isMediaPost)
      res = await _postBloc.getListMediaPostComment(widget.mediaPost.id, filter: filter);
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

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      builder: (context, controller) => Stack(
        children: [
          Scaffold(
            appBar: AppBar1(
              title: 'Comments',
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                      value: sort,
                      style: ptBody().copyWith(color: Colors.black87),
                      items: [
                        DropdownMenuItem(
                          child: Text('Mới nhất'),
                          value: '{createdAt: -1}',
                        ),
                        DropdownMenuItem(
                          child: Text('Cũ nhất'),
                          value: '{createdAt: 1}',
                        ),
                      ],
                      underline: SizedBox.shrink(),
                      onChanged: (val) {
                        setState(() {
                          sort = val;
                        });
                        _getComments(
                            filter: GraphqlFilter(limit: 20, order: val));
                      }),
                )
              ],
            ),
            body: Column(
              children: [
                comments != null
                    ? Expanded(
                        child: ListView.separated(
                          controller: controller,
                          padding: EdgeInsets.zero,
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return CustomListTile(
                              onTap: () {
                                // InboxChat.navigate();
                              },
                              tileColor: Colors.white,
                              leading: Container(
                                padding: EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black45),
                                  shape: BoxShape.circle,
                                ),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundImage: comment.user.avatar != null
                                        ? NetworkImage(comment.user.avatar)
                                        : AssetImage(
                                            'assets/image/default_avatar.png'),
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(top: 13),
                                child: Text(
                                  comment.user?.name ?? '',
                                  style: ptTitle().copyWith(
                                      color: Colors.black87, fontSize: 15),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    comment.content ?? '',
                                    style: ptTiny().copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize: 13.5),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Formart.formatToDate(DateTime.tryParse(
                                            comment.updatedAt)),
                                        style: ptTiny(),
                                      ),
                                      SizedBox(
                                        width: 50,
                                        child: Center(
                                          child: Text(
                                            'Trả lời',
                                            style: ptSmall(),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        child: Row(children: [
                                          Icon(
                                            MdiIcons.thumbUp,
                                            size: 17,
                                            color: comment.isLike
                                                ? Colors.red
                                                : Colors.grey[200],
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            comment.like.toString(),
                                            style: ptTiny(),
                                          )
                                        ]),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox.shrink(),
                        ),
                      )
                    : Spacer(),
                Container(
                  width: deviceWidth(context),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: ptBackgroundColor(context),
                  child: Center(
                    child: TextField(
                      controller: _commentC,
                      maxLines: null,
                      maxLength: 200,
                      onSubmitted: _comment,
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                            onTap: () {
                              _comment(_commentC.text);
                            },
                            child: Icon(Icons.send)),
                        contentPadding: EdgeInsets.all(10),
                        isDense: true,
                        hintText: 'Viết bình luận.',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (comments == null) kLoadingSpinner
        ],
      ),
    );
  }
}
