import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';

class CardPost extends StatefulWidget {
  @override
  _CardPostState createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth(context),
      padding: const EdgeInsets.only(left: 20),
      color: Colors.white,
      child: Row(
        children: [
          _buildAvatar(),
          widthSpace(5),
          Flexible(
            child: _buildCreatePagePost(),
          )
        ],
      ),
    );
  }

  Widget _buildCreatePagePost() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: GestureDetector(
          onTap: () {},
          child: Material(
            borderRadius: BorderRadius.circular(10),
            //elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Text(
                    'Đăng tin của bạn',
                    style: ptTitle(),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.location_pin,
                        size: 21,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: Icon(
                        MdiIcons.image,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildAvatar() => Center(
        child: Container(
          width: 35,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage('assets/image/default_avatar.png',),
          ),
        ),
      );
}
