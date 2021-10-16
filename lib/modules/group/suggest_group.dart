import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/model/group.dart';

class SuggestGroup extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState!.push(pageBuilder(SuggestGroup()));
  }

  const SuggestGroup({Key? key}) : super(key: key);

  @override
  _SuggestGroupState createState() => _SuggestGroupState();
}

class _SuggestGroupState extends State<SuggestGroup> {
  GroupBloc? _groupBloc;
  TextEditingController _searchC = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of<GroupBloc>(context);
      _groupBloc!.getSuggestGroup();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<GroupModel>? searchGroups = _groupBloc!.suggestGroup
        ?.where((element) => element.name!
            .toLowerCase()
            .contains(_searchC.text.trim().toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: ptSecondaryColor(context),
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Danh sách được gợi ý',
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
                onChanged: (text) {
                  setState(() {});
                },
                controller: _searchC,
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
            child: _groupBloc!.suggestGroup == null
                ? ListSkeleton()
                : (_groupBloc!.suggestGroup!.length == 0
                    ? Text('Bạn không có danh sách gợi ý nào')
                    : ListView.separated(
                        itemBuilder: (context, index) {
                          return _buildGroupItem(searchGroups![index]);
                        },
                        itemCount: searchGroups!.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 0),
                      )),
          )
        ],
      ),
    );
  }

  _buildGroupItem(GroupModel group) {
    return GestureDetector(
      onTap: () {
        audioCache.play('tab3.mp3');
        DetailGroupPage.navigate(group);
      },
      child: Container(
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
                  imageUrl: group.coverImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(group.name ?? 'null', style: ptTitle()),
                  Text(
                    '${group.countMember} thành viên • 3 bài đăng/ngày',
                    style: ptTiny(),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                audioCache.play('tab3.mp3');
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ptPrimaryColor(context)),
                padding: EdgeInsets.all(8),
                child: Text(
                  'Tham gia',
                  style: ptSmall().copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
