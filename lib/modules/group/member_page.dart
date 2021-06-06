import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/post/people_widget.dart';
import 'package:datcao/share/import.dart';

class GroupMemberPage extends StatefulWidget {
  final GroupModel groupModel;
  static Future navigate(GroupModel groupModel) {
    return navigatorKey.currentState
        .push(pageBuilder(GroupMemberPage(groupModel)));
  }

  GroupMemberPage(this.groupModel);

  @override
  _GroupMemberPageState createState() => _GroupMemberPageState();
}

class _GroupMemberPageState extends State<GroupMemberPage> {
  GroupBloc _groupBloc;
  UserModel owner;
  List<UserModel> admins;
  List<UserModel> members;
  String search;

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      owner = widget.groupModel.owner;
      UserBloc.instance
          .getListUserIn(widget.groupModel.adminIds ?? [])
          .then((res) {
        if (res.isSuccess) {
          setState(() {
            admins = res.data;
          });
        } else
          showToast(res.errMessage, context);
      });
      UserBloc.instance
          .getListUserIn(widget.groupModel.memberIds ?? [])
          .then((res) {
        if (res.isSuccess) {
          setState(() {
            members = res.data;
          });
        } else
          showToast(res.errMessage, context);
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Thành viên',
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 36,
                          child: Icon(Icons.search, color: Colors.black45)),
                      Expanded(
                        child: TextField(
                          onChanged: (val) => setState(() {
                            search = val;
                          }),
                          decoration: InputDecoration(
                              hintText: 'Tìm kiếm tên',
                              border: InputBorder.none,
                              hintStyle:
                                  ptBody().copyWith(color: Colors.black38)),
                        ),
                      )
                    ],
                  ),
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
                    Text('Quản trị viên', style: ptTitle()),
                  ],
                ),
                SizedBox(height: 15),
                (admins == null)
                    ? ListSkeleton()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return PeopleWidget(admins[index]);
                        },
                        itemCount: admins.length,
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
                    Text('Thành viên', style: ptTitle()),
                  ],
                ),
                SizedBox(height: 15),
                (admins == null)
                    ? ListSkeleton()
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return PeopleWidget(admins[index]);
                        },
                        itemCount: _groupBloc.followingGroups.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14),
                      )
              ],
            ),
          )),
    );
  }
}
