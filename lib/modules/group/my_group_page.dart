import 'package:datcao/modules/bloc/group_bloc.dart';
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
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Nhóm của bạn',
        textColor: ptPrimaryColor(context),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 27),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptSecondaryColor(context),
                      ),
                      child: Center(
                        child: Icon(Icons.group),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text('Nhóm bạn quản lý', style: ptTitle()),
                  ],
                ),
                SizedBox(height: 15),
                (_groupBloc.myGroups == null)
                    ? ListSkeleton()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildGroupItem(_groupBloc.myGroups[index]);
                        },
                        itemCount: _groupBloc.myGroups.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14),
                      ),
                SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(width: 27),
                    Container(
                      height: 33,
                      width: 33,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptSecondaryColor(context),
                      ),
                      child: Center(
                        child: Icon(Icons.group),
                      ),
                    ),
                    SizedBox(width: 15),
                    Text('Nhóm bạn đã tham gia', style: ptTitle()),
                  ],
                ),
                SizedBox(height: 15),
                (_groupBloc.followingGroups == null)
                    ? ListSkeleton()
                    : (_groupBloc.followingGroups.length == 0
                        ? Text('Bạn chưa tham gia nhóm nào')
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _buildGroupItem(
                                  _groupBloc.followingGroups[index]);
                            },
                            itemCount: _groupBloc.followingGroups.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 14),
                          ))
              ],
            ),
          )),
    );
  }

  _buildGroupItem(GroupModel groupModel) {
    return GestureDetector(
      onTap: () {
        DetailGroupPage.navigate(groupModel);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20),
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
    );
  }
}
