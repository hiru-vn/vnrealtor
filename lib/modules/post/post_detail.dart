import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';

class PostDetail extends StatefulWidget {
  final PostModel postModel;

  const PostDetail({Key key, this.postModel}) : super(key: key);
  static Future navigate(PostModel postModel) {
    return navigatorKey.currentState.push(pageBuilder(PostDetail(
      postModel: postModel,
    )));
  }

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<CommentModel> comments;
  TextEditingController _commentC = TextEditingController();
  PostBloc _postBloc;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      _getComments(filter: GraphqlFilter(limit: 20));
    }
    super.didChangeDependencies();
  }

  Future _getComments({GraphqlFilter filter}) async {
    BaseResponse res = await _postBloc
        .getAllCommentByPostId(widget.postModel.id, filter: filter);
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
    text = text.trim();
    if (comments == null) await Future.delayed(Duration(seconds: 1));
    _commentC.clear();
    comments.add(CommentModel(
        content: text,
        like: 0,
        user: AuthBloc.instance.userModel,
        updatedAt: DateTime.now().toIso8601String()));
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res =
        await _postBloc.createComment(text, postId: widget.postModel?.id);
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      widget.postModel.commentIds.add((res.data as CommentModel).id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: 'Bài viết của ${widget.postModel.user.name}',
        automaticallyImplyLeading: true,
        bgColor: ptSecondaryColor(context),
        textColor: ptPrimaryColor(context),
      ),
      body: Column(
        children: [
          PostWidget(widget.postModel, commentCallBack: () {
            
          },),
          comments != null
              ? Expanded(
                  child: ListView.separated(
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
                            border: Border.all(width: 1, color: Colors.black45),
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
                            style: ptTitle()
                                .copyWith(color: Colors.black87, fontSize: 15),
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
                                  Formart.formatToDate(
                                      DateTime.tryParse(comment.updatedAt)),
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
                    separatorBuilder: (context, index) => SizedBox.shrink(),
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
    );
  }
}
