import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';

class PeopleWidget extends StatelessWidget {
  final UserModel user;

  const PeopleWidget(this.user);
  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = Provider.of<UserBloc>(context);
    AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(5).copyWith(bottom: 0),
      child: GestureDetector(
        onTap: () {audioCache.play('tab3.mp3');
          ProfileOtherPage.navigate(user);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                backgroundImage: (user.avatar != null
                    ? CachedNetworkImageProvider(user.avatar!)
                    : AssetImage('assets/image/default_avatar.png')) as ImageProvider<Object>?,
              ),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          user.name ?? '',
                          style: ptTitle().copyWith(fontSize: 14),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        if (UserBloc.isVerified(user)) ...[
                          CustomTooltip(
                            margin: EdgeInsets.only(top: 0),
                            message: 'Tài khoản xác thực',
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue[600],
                              ),
                              padding: EdgeInsets.all(1.3),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 11,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6,
                          ),
                        ],
                        // Image.asset('assets/image/ip.png'),
                        // SizedBox(width: 2),
                        // Text(
                        //   user.totalPost.toString(),
                        //   style: ptBody().copyWith(color: Colors.yellow),
                        // ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          (() {
                            final role = UserBloc.getRole(user);
                            if (role == UserRole.company) return 'Công ty';
                            if (role == UserRole.agent) return 'Nhà môi giới';

                            return 'Người dùng';
                          })(),
                          style: ptSmall().copyWith(color: Colors.grey),
                        ),
                        if (_authBloc.userModel!.followingIds!
                            .contains(user.id)) ...[
                          Text(
                            ' • ',
                            style: ptSmall().copyWith(color: Colors.grey),
                          ),
                          Text(
                            'Đang theo dõi',
                            style: ptSmall().copyWith(color: Colors.blue),
                          ),
                        ]
                        // else if (_authBloc.userModel.followerIds
                        //     .contains(user.id)) ...[
                        //   Text(
                        //     ' • ',
                        //     style: ptSmall().copyWith(color: Colors.grey),
                        //   ),
                        //   Text(
                        //     'Theo dõi bạn',
                        //     style: ptSmall().copyWith(color: Colors.blue),
                        //   ),
                        // ]
                      ],
                    ),
                  ],
                ),
              ),
              if (AuthBloc.instance.userModel != null &&
                  !_authBloc.userModel!.followingIds!.contains(user.id) &&
                  user.id != AuthBloc.instance.userModel!.id)
                GestureDetector(
                  onTap: () {audioCache.play('tab3.mp3');
                    _authBloc.userModel!.followingIds!.add(user.id);
                    user.followerIds!.add(_authBloc.userModel!.id);
                    _userBloc.followUser(user.id);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'Theo dõi',
                      style: ptBody().copyWith(color: Colors.white),
                    ),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }
}
