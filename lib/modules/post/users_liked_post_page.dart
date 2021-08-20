import 'package:auto_size_text/auto_size_text.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_app_bar.dart';
import 'package:datcao/modules/post/post_detail.dart';

class UsersLikePostPage extends StatefulWidget {
  final String postID;
  const UsersLikePostPage({Key key, this.postID}) : super(key: key);
  static Future navigate({String postID}) {
    return navigatorKey.currentState.push(pageBuilder(UsersLikePostPage(
      postID: postID,
    )));
  }

  @override
  _UsersLikePostPageState createState() => _UsersLikePostPageState();
}

class _UsersLikePostPageState extends State<UsersLikePostPage> {
  PostBloc _postBloc;
  PostModel _post;
  UserBloc _userBloc;
  List<UserModel> _users;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
      if (_userBloc == null) {
        _userBloc = Provider.of<UserBloc>(context);
      }
      _getPost(widget.postID);

      super.didChangeDependencies();
    }
  }

  Future _getPost(postID) async {
    var res;
    if (AuthBloc.instance.userModel != null) {
      res = await _postBloc.getOnePost(postID);
    } else {
      res = await _postBloc.getOnePostGuest(postID);
    }
    if (res.isSuccess) {
      setState(() {
        _post = res.data;
      });
      await _getUsersLikedPost(_post);
    } else {
      navigatorKey.currentState.maybePop();
      showToast(res.errMessage, context);
    }
  }

  _getUsersLikedPost(PostModel postModel) async {
    BaseResponse res = await _userBloc.getListUserIn(postModel.userLikeIds);
    if (res.isSuccess) {
      if (mounted)
        setState(() {
          _users = res.data;
        });
    } else {
      showToast('Có lỗi khi lấy dữ liệu', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              "assets/image/back_icon.png",
              width: 30,
            ),
          ),
          title: Expanded(
            child: Center(
              child: AutoSizeText(
                "Xem tương tác",
                style:
                    roboto_18_700().copyWith(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: null)
          ],
        ),
        body: Container(
          child: _users != null && _users.length > 0
              ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: _users.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                    child: Row(
                      children: [
                        UserLikePostAvatar(
                          user: _users[index],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _users[index].name,
                                style: roboto().copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                "Nhà môi giới",
                                style: roboto().copyWith(
                                    fontSize: 13, fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : _users == null
                  ? kLoadingSpinner
                  : SizedBox(),
        ),
      ),
    );
  }
}
