import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/connection/widgets/suggest_items.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/share/import.dart';

class ListGroupConnection extends StatelessWidget {
  final List<GroupModel> groups;
  final GroupBloc groupBloc;
  const ListGroupConnection({
    Key key,
    this.groups,
    this.groupBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: Column(
        children: [
          Container(
            color: ptPrimaryColorLight(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      "assets/image/team_icon.png",
                      width: 30,
                    ),
                  ),
                  Text(
                    "Nhóm mà bạn có thể quan tâm",
                    style: roboto(context).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
              child: StaggeredGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            staggeredTiles: groups.map((_) => StaggeredTile.fit(1)).toList(),
            children: List.generate(
                groupBloc.isLoadGroupSuggest ? 4 : groups.length,
                (index) => groupBloc.isLoadGroupSuggest
                    ? SuggestItemLoading()
                    : GroupSuggestItem(
                        group: groups[index],
                        groupBloc: groupBloc,
                      )),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả",
                  style: roboto(context).copyWith(
                      color: HexColor.fromHex("#009FFD"),
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              Image.asset(
                "assets/image/right_icon.png",
                width: 30,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ListPageConnection extends StatelessWidget {
  final PagesBloc pagesBloc;
  final Function(String) onConnectPage;
  final Function(String) onDeletePage;
  final List<PagesCreate> pages;
  const ListPageConnection({
    Key key,
    this.pages,
    this.onConnectPage,
    this.onDeletePage,
    this.pagesBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _pageBloc = PagesBloc.instance;
    return Container(
      color: ptPrimaryColor(context),
      child: Column(
        children: [
          Container(
              child: StaggeredGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            staggeredTiles: pages.map((_) => StaggeredTile.fit(1)).toList(),
            children: List.generate(
                _pageBloc.isLoadingSuggest ? 4 : pages.length,
                (index) => _pageBloc.isLoadingSuggest
                    ? SuggestItemLoading()
                    : PageSuggestItem(
                        page: pages[index],
                        pagesBloc: pagesBloc,
                      )),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả",
                  style: roboto(context).copyWith(
                      color: HexColor.fromHex("#009FFD"),
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              Image.asset(
                "assets/image/right_icon.png",
                width: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ListUserConnection extends StatelessWidget {
  final List<UserModel> users;
  final UserBloc userBloc;
  const ListUserConnection({
    Key key,
    this.users,
    this.userBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: Column(
        children: [
          Container(
            color: ptPrimaryColorLight(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.asset(
                      "assets/image/team_icon.png",
                      width: 30,
                    ),
                  ),
                  Text(
                    "Gợi ý bạn có thể kết nối",
                    style: roboto(context).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            height: 240,
            child: ListView.builder(
              itemCount: userBloc.isLoadingUserSuggest ? 3 : users.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => userBloc.isLoadingUserSuggest
                  ? SuggestItemLoading()
                  : UserSuggestItem(
                      user: users[index],
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Xem tất cả",
                  style: roboto(context).copyWith(
                      color: HexColor.fromHex("#009FFD"),
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              Image.asset(
                "assets/image/right_icon.png",
                width: 30,
              )
            ],
          )
        ],
      ),
    );
  }
}
