import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import '../profile/profile_other_page.dart';

class SuggestListUser extends StatefulWidget {
  final List<UserModel> users;
  const SuggestListUser({Key key, this.users}) : super(key: key);

  @override
  _SuggestListUserState createState() => _SuggestListUserState();
}

class _SuggestListUserState extends State<SuggestListUser> {
  AuthBloc authBloc;
  UserBloc userBloc;

  @override
  void didChangeDependencies() {
    if (authBloc == null) {
      authBloc = Provider.of(context);
      userBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
          width: deviceWidth(context),
          color: ptPrimaryColor(context),
          padding: const EdgeInsets.only(top: 15, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  AuthBloc.firstLogin
                      ? 'Chào mừng, ${authBloc.userModel.name}'
                      : 'Gợi ý cho bạn',
                  style: ptBigTitle()
                      .copyWith(color: Theme.of(context).accentColor),
                ),
              ),
              if (AuthBloc.firstLogin) ...[
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    'Theo dõi những người dùng khác để nhận được những nội dung phù hợp với bạn.',
                    style: ptBody(),
                  ),
                ),
              ],
              SizedBox(
                height: 12,
              ),
              Container(
                height: 175,
                child: ListView.separated(
                    padding: EdgeInsets.only(right: 20, left: 15),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 128,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: Colors.black12,
                            )),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () {
                                  audioCache.play('tab3.mp3');
                                  ProfileOtherPage.navigate(
                                      widget.users[index]);
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.white,
                                  backgroundImage: widget.users[index].avatar !=
                                          null
                                      ? CachedNetworkImageProvider(
                                          widget.users[index].avatar)
                                      : AssetImage(
                                          'assets/image/default_avatar.png'),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      audioCache.play('tab3.mp3');
                                      ProfileOtherPage.navigate(
                                          widget.users[index]);
                                    },
                                    child: Text(
                                      widget.users[index].name,
                                      style: ptBody().copyWith(
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      audioCache.play('tab3.mp3');
                                      ProfileOtherPage.navigate(
                                          widget.users[index]);
                                    },
                                    child: Text(
                                      (() {
                                        final role = UserBloc.getRole(
                                            widget.users[index]);
                                        if (role == UserRole.company)
                                          return 'Công ty';
                                        if (role == UserRole.agent)
                                          return 'Nhà môi giới';

                                        return 'Người dùng';
                                      })(),
                                      style: ptSmall()
                                          .copyWith(color: Colors.black),
                                    ),
                                  ),
                                ],
                              )),
                              GestureDetector(
                                onTap: () async {
                                  audioCache.play('tab3.mp3');
                                  if (AuthBloc.instance.userModel == null) {
                                    LoginPage.navigatePush();
                                    return;
                                  }
                                  authBloc.userModel.followingIds
                                      .add(widget.users[index].id);

                                  setState(() {});
                                  final res = await userBloc
                                      .followUser(widget.users[index].id);

                                  if (res.isSuccess) {
                                  } else {
                                    showToast(res.errMessage, context);
                                    authBloc.userModel.followingIds
                                        .remove(widget.users[index].id);

                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  width: 90,
                                  padding: EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    border: (AuthBloc.instance.userModel
                                                ?.followingIds
                                                ?.contains(
                                                    widget.users[index].id) ==
                                            true)
                                        ? Border.all(color: Colors.black12)
                                        : Border.all(
                                            color: ptPrimaryColor(context)
                                                .withOpacity(0.2)),
                                    color: (AuthBloc.instance.userModel
                                                ?.followingIds
                                                ?.contains(
                                                    widget.users[index].id) ==
                                            true)
                                        ? Colors.transparent
                                        : ptSecondaryColor(context),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AuthBloc.instance.userModel == null
                                          ? 'Theo dõi'
                                          : (AuthBloc.instance.userModel
                                                  .followerIds
                                                  .contains(
                                                      widget.users[index].id)
                                              ? ((AuthBloc.instance.userModel
                                                      .followingIds
                                                      .contains(widget
                                                          .users[index].id)
                                                  ? 'Bạn bè'
                                                  : 'Theo dõi lại'))
                                              : (AuthBloc.instance.userModel
                                                      .followingIds
                                                      .contains(widget
                                                          .users[index].id)
                                                  ? 'Đã theo dõi'
                                                  : 'Theo dõi')),
                                      style: ptSmall().copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: ptPrimaryColor(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          width: 10,
                        ),
                    itemCount: widget.users.length),
              )
            ],
          )),
    );
  }
}
