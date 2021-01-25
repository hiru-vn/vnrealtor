import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/share/import.dart';

class PeopleWidget extends StatelessWidget {
  final UserModel user;

  const PeopleWidget(this.user);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5).copyWith(bottom: 0),
      child: GestureDetector(
        onTap: () {
          ProfilePage.navigate();
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: user.avatar != null
                    ? NetworkImage(user.avatar)
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
                        style: ptTitle(),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Image.asset('assets/image/coin.png'),
                      SizedBox(width: 2),
                      Text(
                        '3',
                        style: ptBody().copyWith(color: Colors.yellow),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        user.role?.toLowerCase() == 'agency'
                            ? 'Nhà môi giới'
                            : 'Người dùng',
                        style: ptSmall().copyWith(color: Colors.grey),
                      ),
                      if (user.role?.toLowerCase() == 'agency')...[
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
