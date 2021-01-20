import 'package:vnrealtor/modules/profile/profile_page.dart';
import 'package:vnrealtor/share/import.dart';

class SearchPeopleWidget extends StatelessWidget {
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
            padding: const EdgeInsets.all(10),
            child: Row(children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/image/avatar.jpg'),
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Nguyễn Hùng',
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
                        'Nhà môi giới',
                        style: ptSmall().copyWith(color: Colors.grey),
                      ),
                      Text(
                        '  •  ',
                        style: ptSmall().copyWith(color: Colors.grey),
                      ),
                      Text(
                        '3 bài viết',
                        style: ptSmall().copyWith(color: Colors.grey),
                      ),
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
