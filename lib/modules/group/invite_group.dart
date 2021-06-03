import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';

class InviteGroup extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(InviteGroup()));
  }

  const InviteGroup({Key key}) : super(key: key);

  @override
  _InviteGroupState createState() => _InviteGroupState();
}

class _InviteGroupState extends State<InviteGroup> {
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
      backgroundColor: ptSecondaryColor(context),
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Mời bạn bè vào nhóm',
        textColor: ptPrimaryColor(context),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(11),
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: ptBody().copyWith(color: Colors.black38),
                    hintText: 'Tìm kiếm tên nhóm',
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 40, minHeight: 25),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return _buildGroupItem();
              },
              itemCount: 20,
              separatorBuilder: (context, index) => SizedBox(height: 0),
            ),
          )
        ],
      ),
    );
  }

  _buildGroupItem() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Container(
              width: 60,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ptSecondaryColor(context)),
              child: CachedNetworkImage(
                imageUrl: '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên group', style: ptTitle()),
                Text(
                  '100k thành viên • 30 bài đăng/ngày',
                  style: ptTiny(),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: ptPrimaryColor(context)),
              padding: EdgeInsets.all(6),
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 17,
                  ),
                  SizedBox(width: 7),
                  Text(
                    'Mời',
                    style: ptSmall().copyWith(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 3),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
