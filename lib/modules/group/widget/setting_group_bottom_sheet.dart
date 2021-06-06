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

  @override
  void initState() {
    _enableBrowseMember = widget.groupModel.censor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        shrinkWrap: true,
        children: [
          CustomListTile(
            tileColor: Colors.white,
            leading: Container(
              decoration: BoxDecoration(
                color: ptSecondaryColor(context),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(6),
              child: Icon(
                MdiIcons.thumbUp,
                color: ptPrimaryColor(context),
                size: 19,
              ),
            ),
            title: Text(
              'Lượt thích',
              style: ptTitle().copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
            trailing: Switch(
                value: _enableBrowseMember,
                onChanged: (bool val) {
                  setState(() {
                    _enableBrowseMember = !_enableBrowseMember;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
