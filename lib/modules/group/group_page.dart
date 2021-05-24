import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/create_group_page.dart';
import 'package:datcao/modules/group/my_group_page.dart';
import 'package:datcao/modules/group/suggest_group.dart';
import 'package:datcao/share/import.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key key}) : super(key: key);

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Nhóm',
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
            controller: GroupBloc.instance.groupScrollController,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Column(
                children: [
                  _buildHeader(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 27),
              GestureDetector(
                onTap: () {
                  CreateGroupPage.navigate();
                },
                child: Container(
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ptSecondaryColor(context),
                  ),
                  child: Center(
                    child: Icon(Icons.group_add_rounded),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    CreateGroupPage.navigate();
                  },
                  child: SizedBox(width: 15)),
              GestureDetector(
                  onTap: () {
                    CreateGroupPage.navigate();
                  },
                  child: Text('Tạo nhóm mới', style: ptTitle())),
            ],
          ),
          SizedBox(height: 15),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 12),
                _buildButton('Nhóm của bạn', Icons.group_outlined, () {
                  MyGroupPage.navigate();
                }),
                SizedBox(width: 25),
                _buildButton('Gợi ý', Icons.flag_outlined, () {
                  SuggestGroup.navigate();
                }),
                SizedBox(width: 25),
                _buildButton('Lời mời', Icons.mail_outline_rounded, () {})
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButton(String text, IconData icon, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: ptSecondaryColor(context),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 27),
            SizedBox(width: 10),
            Text(text, style: ptTitle().copyWith(fontSize: 13.5))
          ],
        ),
      ),
    );
  }
}
