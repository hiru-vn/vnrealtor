import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class SharePickList extends StatefulWidget {
  final String title;
  SharePickList(this.title);

  @override
  _SharePickListState createState() => _SharePickListState();
}

class _SharePickListState extends State<SharePickList> {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  List<UserModel> friends;
  List<UserModel> followers;
  List<UserModel> tagUsers = [];
  String search = '';

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
      _userBloc = Provider.of(context);
      _userBloc
          .getListUserIn(_authBloc.userModel.followerIds
              .where(
                  (element) => !_authBloc.userModel.friendIds.contains(element))
              .toList())
          .then((value) {
        if (value.isSuccess) {
          setState(() {
            followers = value.data;
          });
        } else
          showToast('Có lỗi khi lấy danh sách, vui lòng đóng trang và thử lại',
              context);
      });
      _userBloc.getListUserIn(_authBloc.userModel.friendIds).then((value) {
        if (value.isSuccess) {
          setState(() {
            friends = value.data;
          });
        } else
          showToast('Có lỗi khi lấy danh sách, vui lòng đóng trang và thử lại',
              context);
      });
    }
    super.didChangeDependencies();
  }

  _tapUser(UserModel user) {
    setState(() {
      if (!tagUsers.contains(user))
        tagUsers.add(user);
      else
        tagUsers.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(widget.title,
              style: ptBigBody().copyWith(color: Colors.black)),
          actions: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => navigatorKey.currentState.pop(tagUsers),
              child: Center(
                child: SizedBox(
                  width: 50,
                  child: Text(
                    'Xong',
                    style: ptTitle(),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Row(
              children: [
                SizedBox(
                    width: 36,
                    child: Icon(Icons.search, color: Colors.black45)),
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() {
                      search = val;
                    }),
                    decoration: InputDecoration(
                        hintText: 'Tìm kiếm tên',
                        border: InputBorder.none,
                        hintStyle: ptBody().copyWith(color: Colors.black38)),
                  ),
                )
              ],
            ),
            Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Bạn bè',
                        style: ptTitle().copyWith(
                            color: Colors.black,
                            fontSize: 13,
                            letterSpacing: 0.2),
                      ),
                    ),
                    Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                    Column(
                      children: [
                        if (friends != null)
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: friends
                                .where((e) => e.name.contains(search))
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return _buildUserItem(
                                  friends
                                      .where((e) => e.name.contains(search))
                                      .toList()[index],
                                  tagUsers.contains(friends
                                      .where((e) => e.name.contains(search))
                                      .toList()[index]),
                                  () => _tapUser(friends
                                      .where((e) => e.name.contains(search))
                                      .toList()[index]));
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                  height: 1,
                                  color: Colors.black12.withOpacity(0.3));
                            },
                          )
                        else
                          _buildUserLoading()
                      ],
                    ),
                    Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Theo dõi bạn',
                        style: ptTitle().copyWith(
                            color: Colors.black,
                            fontSize: 13,
                            letterSpacing: 0.2),
                      ),
                    ),
                    Divider(height: 1, color: Colors.black12.withOpacity(0.3)),
                    Column(
                      children: [
                        if (followers != null)
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: followers
                                .where((e) => e.name.contains(search))
                                .toList()
                                .length,
                            itemBuilder: (context, index) {
                              return _buildUserItem(
                                  followers
                                      .where((e) => e.name.contains(search))
                                      .toList()[index],
                                  tagUsers.contains(followers
                                      .where((e) => e.name.contains(search))
                                      .toList()[index]),
                                  () => _tapUser(followers
                                      .where((e) => e.name.contains(search))
                                      .toList()[index]));
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                  height: 1,
                                  color: Colors.black12.withOpacity(0.3));
                            },
                          )
                        else
                          _buildUserLoading()
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildUserItem(UserModel user, bool isSelect, Function onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Row(
        children: [
          if (!isSelect)
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[200], width: 2),
              ),
            )
          else
            Container(
              width: 19,
              height: 19,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: ptPrimaryColor(context)),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
            ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 15,
            backgroundImage: user.avatar != null
                ? CachedNetworkImageProvider(user.avatar)
                : AssetImage('assets/image/default_avatar.png'),
          ),
          SizedBox(width: 14),
          Text(user.name, style: ptBody().copyWith(color: Colors.black)),
        ],
      ),
    );
  }

  _buildUserLoading() {
    return SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      items: 3,
      period: Duration(seconds: 2),
      highlightColor: Colors.grey[200],
      direction: SkeletonDirection.ltr,
    );
  }
}
