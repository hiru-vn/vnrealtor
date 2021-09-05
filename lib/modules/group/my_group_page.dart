import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/connection/widgets/suggest_items.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/share/import.dart';

class MyGroupPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(MyGroupPage()));
  }

  MyGroupPage({Key key}) : super(key: key);

  @override
  _MyGroupPageState createState() => _MyGroupPageState();
}

class _MyGroupPageState extends State<MyGroupPage> {
  GroupBloc _groupBloc;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      _groupBloc.init();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SecondAppBar(
        title: 'Nhóm của bạn',
      ),
      body: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            audioCache.play('tab3.mp3');
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: ptPrimaryColorLight(context),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        height: 33,
                        width: 33,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ptPrimaryColor(context),
                        ),
                        child: Center(
                          child: Icon(Icons.group),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text('Nhóm bạn quản lý', style: ptTitle()),
                    ],
                  ),
                ),
                (_groupBloc.myGroups == null)
                    ? ListSkeleton()
                    : (_groupBloc.myGroups.length == 0)
                        ? Text('Bạn quản lý nhóm nào')
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: GridView.count(
                              crossAxisCount:
                                  (MediaQuery.of(context).size.width / 200)
                                      .round(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              childAspectRatio: .8,
                              children: List.generate(
                                  _groupBloc.myGroups == null
                                      ? 4
                                      : _groupBloc.myGroups.length,
                                  (index) => _groupBloc.myGroups == null
                                      ? SuggestItemLoading()
                                      : GroupSuggestItem(
                                          group: _groupBloc.myGroups[index],
                                          groupBloc: _groupBloc,
                                        )),
                            )),
                Container(
                  color: ptPrimaryColorLight(context),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        height: 33,
                        width: 33,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ptPrimaryColor(context),
                        ),
                        child: Center(
                          child: Icon(Icons.group),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text('Nhóm bạn đã tham gia', style: ptTitle()),
                    ],
                  ),
                ),
                if (_groupBloc.followingGroups != null) SizedBox(height: 15),
                Container(
                    child: GridView.count(
                  crossAxisCount:
                      (MediaQuery.of(context).size.width / 200).round(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  childAspectRatio: .8,
                  children: List.generate(
                      _groupBloc.followingGroups == null
                          ? 4
                          : _groupBloc.followingGroups.length,
                      (index) => _groupBloc.followingGroups == null
                          ? SuggestItemLoading()
                          : GroupSuggestItem(
                              group: _groupBloc.followingGroups[index],
                              groupBloc: _groupBloc,
                            )),
                )),
              ],
            ),
          )),
    );
  }

  _buildGroupItem(GroupModel groupModel) {
    return GestureDetector(
      onTap: () {
        audioCache.play('tab3.mp3');
        DetailGroupPage.navigate(groupModel).then((value) {
          _groupBloc.getMyGroup();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: ptPrimaryColor(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 70,
                  height: 40,
                  color: ptSecondaryColor(context),
                  child: CachedNetworkImage(
                    imageUrl: groupModel.coverImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(groupModel.name, style: ptTitle()),
                  Text(
                    'Nội dung mới: ${Formart.timeByDayVi(DateTime.tryParse(groupModel.updatedAt))}',
                    style: ptTiny(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
