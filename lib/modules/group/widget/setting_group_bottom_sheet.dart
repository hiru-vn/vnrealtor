import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/model/group.dart';
import 'package:datcao/share/import.dart';

Future showSettingGroup(BuildContext context, GroupModel groupModel) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return SettingGroup(groupModel);
      });
}

class SettingGroup extends StatefulWidget {
  final GroupModel groupModel;
  SettingGroup(this.groupModel, {Key key}) : super(key: key);

  @override
  _SettingGroupState createState() => _SettingGroupState();
}

class _SettingGroupState extends State<SettingGroup> {
  bool _enableBrowseMember = false;
  GroupBloc _groupBloc;

  @override
  void initState() {
    _enableBrowseMember = widget.groupModel.censor ?? false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Cài đặt nhóm', style: ptTitle()),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () async {
                      showWaitingDialog(context);
                      final res = await _groupBloc.browseMemberSetting(
                          widget.groupModel.id, _enableBrowseMember);
                      closeLoading();
                      if (res.isSuccess) {
                        navigatorKey.currentState.maybePop(res.data);
                      } else {
                        showToast(res.errMessage, context);
                      }
                    })
              ],
            ),
            Row(
              children: [
                Text(
                  'Duyệt thành viên',
                  style: ptBody().copyWith(color: Colors.black54),
                ),
                Spacer(),
                Switch(
                    value: _enableBrowseMember,
                    onChanged: (bool val) {
                      setState(() {
                        _enableBrowseMember = !_enableBrowseMember;
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
