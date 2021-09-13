import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/appbar.dart';

class SettingNotifyPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(SettingNotifyPage()));
  }

  @override
  _SettingNotifyPageState createState() => _SettingNotifyPageState();
}

class _SettingNotifyPageState extends State<SettingNotifyPage> {
  bool isLike = false;
  bool isComment = true;
  bool isShare = true;
  bool isPost = true;
  AuthBloc _authBloc;
  UserBloc _userBloc;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
      _userBloc = Provider.of(context);
      if (_authBloc.userModel.setting != null) {
        isLike = _authBloc.userModel.setting.likeNoti ?? false;
        isComment = _authBloc.userModel.setting.commentNoti ?? true;
        isShare = _authBloc.userModel.setting.shareNoti ?? true;
        isPost = _authBloc.userModel.setting.postNoti ?? true;
      }
    }
    super.didChangeDependencies();
  }

  _updateSetting() async {
    _authBloc.userModel.setting
      ..likeNoti = isLike
      ..commentNoti = isComment
      ..shareNoti = isShare
      ..postNoti = isPost;
    final res = await _userBloc.updateSetting(_authBloc.userModel.setting);
    if (res.isSuccess) {
    } else {
      showToast('Có lỗi xảy ra, thay đổi của bạn không được lưu', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _updateSetting();
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: ptBackgroundColor(context),
        appBar: SecondAppBar(
          title: 'Cài đặt nhận thông báo',
        ),
        body: Column(children: [
          SizedBox(
            height: 20,
          ),
          CustomListTile(
            tileColor: Colors.white,
            leading: Container(
              decoration: BoxDecoration(
                color: ptSecondaryColor(context),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                MdiIcons.thumbUp,
                color: ptPrimaryColor(context),
                size: 19,
              ),
            ),
            title: Text(
              'Lượt thích',
              style: ptTitle().copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            // subtitle: Text(
            //   'Khi có người thích bài viết hoặc bình luận',
            //   style: ptTiny().copyWith(color: Colors.black54),
            // ),
            trailing: Switch(
                value: isLike,
                onChanged: (bool val) {
                  setState(() {
                    isLike = !isLike;
                  });
                }),
          ),
          SizedBox(
            height: 5,
          ),
          CustomListTile(
            tileColor: Colors.white,
            leading: Container(
              decoration: BoxDecoration(
                color: ptSecondaryColor(context),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                MdiIcons.chat,
                color: ptPrimaryColor(context),
                size: 19,
              ),
            ),
            title: Text(
              'Bình luận',
              style: ptTitle().copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            // subtitle: Text(
            //   'Khi có người bình luận',
            //   style: ptTiny().copyWith(color: Colors.black54),
            // ),
            trailing: Switch(
                value: isComment,
                onChanged: (bool val) {
                  setState(() {
                    isComment = !isComment;
                  });
                }),
          ),
          SizedBox(
            height: 5,
          ),
          CustomListTile(
            tileColor: Colors.white,
            leading: Container(
              decoration: BoxDecoration(
                color: ptSecondaryColor(context),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                MdiIcons.share,
                color: ptPrimaryColor(context),
                size: 19,
              ),
            ),
            title: Text(
              'Chia sẻ',
              style: ptTitle().copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            // subtitle: Text(
            //   'Khi có người chia sẻ bài viết',
            //   style: ptTiny().copyWith(color: Colors.black54),
            // ),
            trailing: Switch(
                value: isShare,
                onChanged: (bool val) {
                  setState(() {
                    isShare = !isShare;
                  });
                }),
          ),
          SizedBox(
            height: 5,
          ),
          CustomListTile(
            tileColor: Colors.white,
            leading: Container(
              decoration: BoxDecoration(
                color: ptSecondaryColor(context),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                MdiIcons.newspaper,
                color: ptPrimaryColor(context),
                size: 19,
              ),
            ),
            title: Text(
              'Từ bài viết khác',
              style: ptTitle().copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            // subtitle: Text(
            //   'Khi có người chia sẻ bài viết',
            //   style: ptTiny().copyWith(color: Colors.black54),
            // ),
            trailing: Switch(
                value: isPost,
                onChanged: (bool val) {
                  setState(() {
                    isPost = !isPost;
                  });
                }),
          ),
        ]),
      ),
    );
  }
}
