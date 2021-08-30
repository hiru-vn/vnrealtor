import 'package:datcao/share/import.dart';

class ConnectionItem extends StatelessWidget {
  final Function onTap;
  final Widget preIcon;
  final Widget subIcon;
  final String text;
  const ConnectionItem({
    Key key,
    this.preIcon,
    this.subIcon,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Row(
            children: [
              preIcon,
              SizedBox(
                width: 10,
              ),
              Text(
                text,
                style: roboto().copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              subIcon
            ],
          ),
        ),
      ),
    );
  }
}
