import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/loading_widgets/shimmer_widget.dart';
import 'package:datcao/utils/role_user.dart';

class UserConnectItem extends StatefulWidget {
  final UserBloc userBloc;
  final UserModel user;
  final List<Widget> actions;

  const UserConnectItem({
    Key key,
    this.user,
    this.userBloc,
    this.actions,
  }) : super(key: key);

  @override
  _UserConnectItemState createState() => _UserConnectItemState();
}

class _UserConnectItemState extends State<UserConnectItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ProfileOtherPage.navigate(widget.user),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        color: ptPrimaryColor(context),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                backgroundImage: widget.user.avatar != null
                    ? CachedNetworkImageProvider(widget.user.avatar)
                    : AssetImage('assets/image/default_avatar.png'),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${widget.user.name}",
                      style: roboto(context)
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "${widget.user.totalPoint}",
                        ),
                        Image.asset(
                          "assets/image/guarantee.png",
                          width: 18,
                        )
                      ],
                    )
                  ],
                ),
                Text(
                  "${convertRoleUser(widget.user.role)}",
                  style: roboto(context)
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            Spacer(),
            ...widget?.actions,
          ],
        ),
      ),
    );
  }
}

class UserConnectItemLoading extends StatelessWidget {
  const UserConnectItemLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: ptPrimaryColor(context),
      child: Row(
        children: [
          ShimmerWidget.cirular(width: 40, height: 40),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget.rectangular(height: 10, width: 250),
              SizedBox(
                height: 10,
              ),
              ShimmerWidget.rectangular(
                height: 10,
                width: deviceWidth(context) / 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
