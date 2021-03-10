import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/custom_tooltip.dart';

class PeopleWidget extends StatelessWidget {
  final UserModel user;

  const PeopleWidget(this.user);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5).copyWith(bottom: 0),
      child: GestureDetector(
        onTap: () {
          ProfileOtherPage.navigate(user);
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              CircleAvatar(
                radius: 22,backgroundColor: Colors.white,
                backgroundImage: user.avatar != null
                    ? CachedNetworkImageProvider(user.avatar)
                    : AssetImage('assets/image/default_avatar.png'),
              ),
              SizedBox(width: 13),
              Column(
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
                      if (user?.role == 'AGENT') ...[
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
                      Image.asset('assets/image/coin.png'),
                      SizedBox(width: 2),
                      Text(
                        user.totalPost.toString(),
                        style: ptBody().copyWith(color: Colors.yellow),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        user.role?.toUpperCase() == 'AGENT'
                            ? 'Nhà môi giới'
                            : 'Người dùng',
                        style: ptSmall().copyWith(color: Colors.grey),
                      ),
                      if (user.role?.toUpperCase() == 'AGENT') ...[
                        Text(
                          '  •  ',
                          style: ptSmall().copyWith(color: Colors.grey),
                        ),
                        Text(
                          '3 bài viết',
                          style: ptSmall().copyWith(color: Colors.grey),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
              Spacer(),
              // Center(
              //   child: IconButton(
              //     icon: Icon(Icons.more_vert),
              //     onPressed: () {},
              //   ),
              // ),
            ]),
          ),
        ),
      ),
    );
  }
}
