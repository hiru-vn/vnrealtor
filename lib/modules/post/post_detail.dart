import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/comment.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/comment_page.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/share/import.dart';

class PostDetail extends StatefulWidget {
  final PostModel postModel;
  final String postId;

  const PostDetail({Key key, this.postModel, this.postId}) : super(key: key);
  static Future navigate(PostModel postModel, {String postId}) {
    return navigatorKey.currentState.push(pageBuilder(PostDetail(
      postModel: postModel,
      postId: postId,
    )));
  }

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  List<CommentModel> comments;
  TextEditingController _commentC = TextEditingController();
  PostBloc _postBloc;
  PostModel _post;

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      if (widget.postModel != null) {
        _post = widget.postModel;
        _getComments(_post.id, filter: GraphqlFilter(limit: 20));
      } else {
        _getPost();
        _getComments(widget.postId, filter: GraphqlFilter(limit: 20));
      }
    }
    super.didChangeDependencies();
  }

  Future _getPost() async {
    final res = await _postBloc.getOnePost(widget.postId);
    if (res.isSuccess) {
      setState(() {
        _post = res.data;
      });
    } else {
      navigatorKey.currentState.maybePop();
      showToast(res.errMessage, context);
    }
  }

  Future _getComments(String postId, {GraphqlFilter filter}) async {
    BaseResponse res =
        await _postBloc.getAllCommentByPostId(postId, filter: filter);
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
    setState(() {});
    FocusScope.of(context).requestFocus(FocusNode());
    BaseResponse res = await _postBloc.createComment(text, postId: _post?.id);
    if (!res.isSuccess) {
      showToast(res.errMessage, context);
    } else {
      _post.commentIds.add((res.data as CommentModel).id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        centerTitle: true,
        title: _post != null ? 'Bài viết của ${_post.user.name}' : '',
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _post == null
                      ? PostSkeleton(
                          count: 1,
                        )
                      : PostWidget(
                          _post,
                          commentCallBack: () {},
                        ),
                  comments != null
                      ? ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: comments.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return new CommentWidget(comment: comment);
                          },
                          separatorBuilder: (context, index) =>
                              SizedBox.shrink(),
                        )
                      : ListSkeleton(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: deviceWidth(context),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              color: Colors.white70,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 21,
                    backgroundColor: Colors.white,
                    backgroundImage: AuthBloc.instance.userModel.avatar != null
                        ? NetworkImage(AuthBloc.instance.userModel.avatar)
                        : AssetImage('assets/image/default_avatar.png'),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _commentC,
                      maxLines: null,
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
                            onTap: () {
                              _comment(_commentC.text);
                            },
                            child: Icon(Icons.send)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                        isDense: true,
                        hintText: 'Viết bình luận.',
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
}
