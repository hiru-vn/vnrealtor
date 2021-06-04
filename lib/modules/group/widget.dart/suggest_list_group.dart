import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/authentication/login.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/share/import.dart';
import '../../bloc/group_bloc.dart';

class SuggestListGroup extends StatefulWidget {
  final List<GroupModel> groups;
  const SuggestListGroup({Key key, @required this.groups}) : super(key: key);

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
    if (widget.groups == null || widget.groups.length == 0)
      return SizedBox.shrink();
    return Container(
      height: 175,
      color: Colors.white,
      width: deviceWidth(context),
      child: ListView.separated(
          padding: EdgeInsets.only(right: 20, left: 15),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              width: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: Colors.black12,
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      // ProfileOtherPage.navigate(
                      //     widget.users[index]);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(7)),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: 180,
                            height: 100,
                            child: CachedNetworkImage(
                              imageUrl: widget.groups[index].coverImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 8,
                            child: Text(
                              widget.groups[index].name,
                              style: ptBody().copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // ProfileOtherPage.navigate(
                          //     widget.users[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            widget.groups[index].privacy
                                ? 'Riêng tư'
                                : 'Công khai' +
                                    ' • ${widget.groups[index].countMember} thành viên',
                            style: ptTiny().copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  )),
                  GestureDetector(
                    onTap: () async {
                      if (AuthBloc.instance.userModel == null) {
                        LoginPage.navigatePush();
                        return;
                      }

                      setState(() {});
                      final res =
                          await groupBloc.joinGroup(widget.groups[index].id);

                      if (res.isSuccess) {
                      } else {
                        showToast(res.errMessage, context);

                        setState(() {});
                      }
                    },
                    child: Container(
                      width: 105,
                      padding: EdgeInsets.symmetric(vertical: 7),
                      decoration: BoxDecoration(
                        border: groupBloc?.followingGroups?.any(
                                    (e) => e.id == widget.groups[index].id) ==
                                true
                            ? Border.all(color: Colors.black12)
                            : Border.all(
                                color:
                                    ptPrimaryColor(context).withOpacity(0.2)),
                        color: groupBloc?.followingGroups?.any(
                                    (e) => e.id == widget.groups[index].id) ==
                                true
                            ? Colors.transparent
                            : ptSecondaryColor(context),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          groupBloc?.followingGroups?.any(
                                      (e) => e.id == widget.groups[index].id) ==
                                  true
                              ? 'Đã tham gia'
                              : 'Tham gia',
                          style: ptSmall().copyWith(
                            fontWeight: FontWeight.w600,
                            color: ptPrimaryColor(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                width: 10,
              ),
          itemCount: widget.groups.length),
    );
  }
}
