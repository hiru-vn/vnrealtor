import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import '../profile/profile_other_page.dart';

class SuggestList extends StatefulWidget {
  final List<UserModel> users;
  const SuggestList({Key key, this.users}) : super(key: key);

  @override
  _SuggestListState createState() => _SuggestListState();
}

class _SuggestListState extends State<SuggestList> {
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
          color: Colors.white,
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
                  style: ptBigTitle().copyWith(color: Colors.black),
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
                height: 190,
                child: ListView.separated(
                    padding: EdgeInsets.only(right: 20, left: 15),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: Colors.black12,
                            )),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
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
                                  Text(
                                    widget.users[index].name,
                                    style: ptTitle(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    (() {
                                      final role =
                                          UserBloc.getRole(widget.users[index]);
                                      if (role == UserRole.company)
                                        return 'Công ty';
                                      if (role == UserRole.agent)
                                        return 'Nhà môi giới';

                                      return 'Người dùng';
                                    })(),
                                    style:
                                        ptSmall().copyWith(color: Colors.black),
                                  ),
                                ],
                              )),
                              GestureDetector(
                                onTap: () async {
                                  if (AuthBloc.instance.userModel == null) {
                                    LoginPage.navigatePush();
                                    return;
                                  }
                                  authBloc.userModel.followingIds
                                      .add(widget.users[index].id);
                                  userBloc.suggestFollowUsers
                                      .remove(widget.users[index]);
                                  setState(() {});
                                  final res = await userBloc
                                      .followUser(widget.users[index].id);

                                  if (res.isSuccess) {
                                  } else {
                                    showToast(res.errMessage, context);
                                    authBloc.userModel.followingIds
                                        .remove(widget.users[index].id);
                                    userBloc.suggestFollowUsers
                                        .add(widget.users[index]);
                                    setState(() {});
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: ptSecondaryColor(context),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    'Theo dõi',
                                    style: ptTitle().copyWith(
                                        color: ptPrimaryColor(context)),
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
