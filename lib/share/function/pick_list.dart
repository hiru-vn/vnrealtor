// show a list of string options
// when user tap on one, excute a callback function with string value as param

import 'package:datcao/share/import.dart';

class PickListItem {
  dynamic value;
  String display;

  PickListItem(this.value, this.display);
}

void pickList(BuildContext context,
    {String closeText,
    String title,
    @required List<PickListItem> options,
    @required Function(dynamic) onPicked}) {
  if (options == null) return;
  showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: ptPrimaryColor(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: deviceHeight(context) * 0.75),
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                          color: ptPrimaryColor(context),
                          borderRadius: BorderRadius.circular(4)),
                      width: deviceWidth(context) - 30,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20).copyWith(bottom: 10),
                            child: Text(title ?? 'Chọn', style: ptTitle()),
                          ),
                          ...options?.map(
                            (e) => InkWell(
                              onTap: () {
                                navigatorKey.currentState.maybePop(e.value);
                                onPicked(e.value);
                              },
                              child: OptionItem(
                                text: e.display,
                                color: ptPrimaryColor(context),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ExpandBtn(
                  color: ptPrimaryColorLight(context),
                  text: 'Hủy',
                  height: 50,
                  borderRadius: 4,
                  onPress: () => navigatorKey.currentState.maybePop(),
                ),
              ),
              SpacingBox(h: 4),
            ],
          ),
        );
      }).then((value) => FocusScope.of(context).requestFocus(FocusNode()));
}

class OptionItem extends StatelessWidget {
  final Color color;
  final String text;

  const OptionItem({Key key, this.color, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.maxFinite,
      color: color ?? ptPrimaryColorLight(context),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(20).copyWith(bottom: 0, top: 0),
          child: Text(text),
        ),
      ),
    );
  }
}
