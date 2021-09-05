import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/loading_widgets/shimmer_widget.dart';
import 'package:datcao/utils/role_user.dart';

class UserSuggestItem extends StatelessWidget {
  final UserModel user;
  final UserBloc userBloc;
  const UserSuggestItem({
    Key key,
    this.user,
    this.userBloc,
  }) : super(key: key);
  void onDeleteUser(String uID) {
    userBloc.deleteSuggestFollow(uID);
  }

  void onFolowUser(String uID) async {
    userBloc.followUser(uID);
    await userBloc.deleteSuggestFollow(uID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: ptPrimaryColor(context),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/image/anhbia.png",
                  height: 60,
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: GestureDetector(
                    onTap: () {
                      audioCache.play('tab3.mp3');
                      ProfileOtherPage.navigate(user);
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      backgroundImage: user.avatar != null
                          ? CachedNetworkImageProvider(user.avatar)
                          : AssetImage('assets/image/default_avatar.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    audioCache.play('tab3.mp3');
                    ProfileOtherPage.navigate(user);
                  },
                  child: Text(
                    user.name,
                    style: roboto(context).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: HexColor.fromHex("#505050")),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${convertRoleUser(user.role)}",
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          user.totalPoint.toString(),
                        ),
                        Image.asset(
                          "assets/image/guarantee.png",
                          width: 18,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/image/link_icon.png",
                      width: 15,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "${user.followerIds.length} Kết nối",
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    onFolowUser(user.id);
                  },
                  child: Container(
                    width: 110,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text("Kết nối"),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  onDeleteUser(user.id);
                },
                child: Image.asset(
                  "assets/image/close_icon.png",
                  width: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GroupSuggestItem extends StatelessWidget {
  final GroupModel group;
  final GroupBloc groupBloc;
  const GroupSuggestItem({
    Key key,
    this.group,
    this.groupBloc,
  }) : super(key: key);

  void onDeleteGroup(String id) {
    groupBloc.deleteSuggestGroup(id);
  }

  void onJoinGroup(String id) {
    groupBloc.joinGroup(id);
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthBloc.instance.userModel.id;
    return GestureDetector(
      onTap: () {
        audioCache.play('tab3.mp3');
        DetailGroupPage.navigate(null, groupId: group.id);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: ptPrimaryColor(context),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Container(
                width: 200,
                child: Image.asset(
                  "assets/image/anhbia.png",
                  height: 60,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Image(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      image: group.coverImage != null
                          ? CachedNetworkImageProvider(group.coverImage)
                          : AssetImage('assets/image/default_avatar.png'),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 35,
                    child: Text(
                      group.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: roboto(context).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: HexColor.fromHex("#505050")),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${group.countMember} thành viên"),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  group.memberIds.contains(userId)
                      ? GestureDetector(
                          onTap: () {
                            audioCache.play('tab3.mp3');
                            DetailGroupPage.navigate(null, groupId: group.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text("Đã tham gia"),
                            ),
                          ),
                        )
                      : group.pendingMemberIds.contains(userId)
                          ? Container(
                              width: 110,
                              height: 30,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: Colors.blueAccent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text("Đã gửi lời mời"),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                onJoinGroup(group.id);
                              },
                              child: Container(
                                width: 110,
                                height: 30,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center(
                                  child: Text("Kết nối"),
                                ),
                              ),
                            )
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    onDeleteGroup(group.id);
                  },
                  child: Image.asset(
                    "assets/image/close_icon.png",
                    width: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestItemLoading extends StatelessWidget {
  const SuggestItemLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 180,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: ptPrimaryColor(context),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            ShimmerWidget.rectangular(
              height: 60,
              width: double.infinity,
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ShimmerWidget.cirular(width: 60, height: 60),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ShimmerWidget.rectangular(
                    height: 10,
                    width: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ShimmerWidget.rectangular(
                    height: 10,
                    width: 80,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ShimmerWidget.rectangular(
                    height: 10,
                    width: 80,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ShimmerWidget.rectangular(
                    height: 30,
                    width: 60,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageSuggestItem extends StatelessWidget {
  final PagesBloc pagesBloc;

  final PagesCreate page;
  const PageSuggestItem({
    Key key,
    this.page,
    this.pagesBloc,
  }) : super(key: key);
  void onDeletePage(String id) {
    pagesBloc.deleteSuggestPage(id);
  }

  void onFollowPage(String id) {
    pagesBloc.followPage(id);
    pagesBloc.suggestFollow();
  }

  @override
  Widget build(BuildContext context) {
    final userId = AuthBloc.instance.userModel.id;
    return GestureDetector(
      onTap: () => PageDetail.navigate(page),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: ptPrimaryColor(context),
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/image/anhbia.png",
                    height: 60,
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image(
                      image: page.avartar != null
                          ? CachedNetworkImageProvider(page.avartar)
                          : AssetImage('assets/image/default_avatar.png'),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    page.name,
                    style: roboto(context).copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: HexColor.fromHex("#505050")),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${page.followers.length} follow"),
                      SizedBox(
                        width: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "7",
                          ),
                          Image.asset(
                            "assets/image/guarantee.png",
                            width: 18,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  page.followerIds.contains(userId)
                      ? GestureDetector(
                          onTap: () {
                            onFollowPage(page.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text("Bỏ theo dõi"),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            onFollowPage(page.id);
                          },
                          child: Container(
                            width: 110,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Theo dõi",
                              ),
                            ),
                          ),
                        )
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    onDeletePage(page.id);
                  },
                  child: Image.asset(
                    "assets/image/close_icon.png",
                    width: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
