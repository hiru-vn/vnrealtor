import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/connection/widgets/suggest_items.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';
import 'package:datcao/modules/model/group.dart';

class SuggestGroup extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(SuggestGroup()));
  }

  const SuggestGroup({Key key}) : super(key: key);

  @override
  _SuggestGroupState createState() => _SuggestGroupState();
}

class _SuggestGroupState extends State<SuggestGroup> {
  GroupBloc _groupBloc;
  TextEditingController _searchC = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
      _groupBloc.getSuggestGroup();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<GroupModel> searchGroups = _groupBloc.suggestGroup
        ?.where((element) => element.name
            .toLowerCase()
            .contains(_searchC.text.trim().toLowerCase()))
        ?.toList();
    return Scaffold(
      appBar: SecondAppBar(
        title: 'Danh sách được gợi ý',
      ),
      body: ListView(
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
                    fillColor: ptPrimaryColorLight(context),
                    hintStyle: ptBody(),
                    hintText: 'Tìm kiếm tên nhóm',
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 40, minHeight: 25),
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            child: _groupBloc.suggestGroup == null
                ? ListSkeleton()
                : (_groupBloc.suggestGroup.length == 0
                    ? Text('Bạn không có danh sách gợi ý nào')
                    : StaggeredGridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        staggeredTiles: _groupBloc.suggestGroup
                            .map((_) => StaggeredTile.fit(1))
                            .toList(),
                        children: List.generate(
                            _groupBloc.suggestGroup == null
                                ? 4
                                : searchGroups.length,
                            (index) => _groupBloc.suggestGroup == null
                                ? SuggestItemLoading()
                                : GroupSuggestItem(
                                    group: searchGroups[index],
                                    groupBloc: _groupBloc,
                                  )),
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
                  imageUrl: group.coverImage,
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
