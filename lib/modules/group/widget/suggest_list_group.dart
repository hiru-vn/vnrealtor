import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/connection/widgets/suggest_items.dart';
import 'package:datcao/modules/group/detail_group_page.dart';
import 'package:datcao/share/import.dart';
import '../../bloc/group_bloc.dart';

class SuggestListGroup extends StatefulWidget {
  const SuggestListGroup({Key key}) : super(key: key);

  @override
  _SuggestListGroupState createState() => _SuggestListGroupState();
}

class _SuggestListGroupState extends State<SuggestListGroup> {
  GroupBloc groupBloc;

  @override
  void didChangeDependencies() {
    if (groupBloc == null) {
      groupBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (groupBloc.suggestGroup == null || groupBloc.suggestGroup.length == 0)
      return SizedBox.shrink();
    return Container(
      height: 260,
      color: ptPrimaryColor(context),
      width: deviceWidth(context),
      child: ListView.separated(
          padding: EdgeInsets.only(right: 20, left: 15),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 200,
              child: GroupSuggestItem(
                groupBloc: groupBloc,
                group: groupBloc.suggestGroup[index],
              ),
            );
            // Container(
            //   width: 180,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(7),
            //       border: Border.all(
            //         color: Colors.black12,
            //       )),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           audioCache.play('tab3.mp3');
            //           // ProfileOtherPage.navigate(
            //           //     widget.users[index]);
            //         },
            //         child: ClipRRect(
            //           borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(7),
            //               topRight: Radius.circular(7)),
            //           child: Stack(
            //             children: [
            //               GestureDetector(
            //                 onTap: () {
            //                   audioCache.play('tab3.mp3');
            //                   DetailGroupPage.navigate(null,
            //                       groupId: groupBloc.suggestGroup[index].id);
            //                 },
            //                 child: SizedBox(
            //                   width: 180,
            //                   height: 100,
            //                   child: CachedNetworkImage(
            //                     imageUrl:
            //                         groupBloc.suggestGroup[index].coverImage,
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //               Positioned(
            //                 bottom: 0,
            //                 left: 0,
            //                 child: Container(
            //                   width: 180,
            //                   padding: EdgeInsets.symmetric(
            //                       vertical: 4, horizontal: 6),
            //                   color: Colors.black26,
            //                   child: ConstrainedBox(
            //                     constraints: BoxConstraints(maxWidth: 164),
            //                     child: Text(
            //                       groupBloc.suggestGroup[index].name,
            //                       style: ptBody().copyWith(
            //                           fontWeight: FontWeight.w600,
            //                           color: Colors.white),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //           child: Column(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.symmetric(vertical: 8.0),
            //             child: Text(
            //               groupBloc.suggestGroup[index].privacy
            //                   ? 'Nhóm kín'
            //                   : 'Công khai' +
            //                       ' • ${groupBloc.suggestGroup[index].countMember} thành viên',
            //               style: ptTiny().copyWith(color: Colors.black),
            //             ),
            //           ),
            //         ],
            //       )),
            //       GestureDetector(
            //         onTap: () async {
            //           audioCache.play('tab3.mp3');
            //           if (AuthBloc.instance.userModel == null) {
            //             LoginPage.navigatePush();
            //             return;
            //           }

            //           setState(() {});
            //           final res = await groupBloc
            //               .joinGroup(groupBloc.suggestGroup[index].id);

            //           if (res.isSuccess) {
            //           } else {
            //             showToast(res.errMessage, context);

            //             setState(() {});
            //           }
            //         },
            //         child: Container(
            //           width: 105,
            //           padding: EdgeInsets.symmetric(vertical: 7),
            //           decoration: BoxDecoration(
            //             border: groupBloc?.followingGroups?.any((e) =>
            //                         e.id == groupBloc.suggestGroup[index].id) ==
            //                     true
            //                 ? Border.all(color: ptMainColor(context))
            //                 : Border.all(color: ptMainColor(context)),
            //             color: groupBloc?.followingGroups?.any((e) =>
            //                         e.id == groupBloc.suggestGroup[index].id) ==
            //                     true
            //                 ? Colors.transparent
            //                 : ptPrimaryColor(context),
            //             borderRadius: BorderRadius.circular(15),
            //           ),
            //           child: Center(
            //             child: Text(
            //                 groupBloc?.followingGroups?.any((e) =>
            //                             e.id ==
            //                             groupBloc.suggestGroup[index].id) ==
            //                         true
            //                     ? 'Đã tham gia'
            //                     : 'Kết nối',
            //                 style: ptSmall()),
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         height: 8,
            //       ),
            //     ],
            //   ),
            // );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
          itemCount: groupBloc.suggestGroup.length),
    );
  }
}
