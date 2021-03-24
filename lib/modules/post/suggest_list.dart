import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';

class SuggestList extends StatelessWidget {
  final List<UserModel> users;
  const SuggestList({Key key, this.users}) : super(key: key);

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
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(
                  'Gợi ý cho bạn',
                  style: ptBigTitle().copyWith(color: Colors.black),
                ),
              ),
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
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: users[index].avatar != null
                                    ? CachedNetworkImageProvider(
                                        users[index].avatar)
                                    : AssetImage(
                                        'assets/image/default_avatar.png'),
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    users[index].name,
                                    style: ptTitle(),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    users[index].role?.toUpperCase() == 'AGENT'
                                        ? 'Nhà môi giới'
                                        : 'Người dùng',
                                    style:
                                        ptSmall().copyWith(color: Colors.black),
                                  ),
                                ],
                              )),
                              GestureDetector(
                                onTap: () {},
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
                    itemCount: users.length),
              )
            ],
          )),
    );
  }
}
