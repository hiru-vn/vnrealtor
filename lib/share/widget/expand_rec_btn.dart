import 'package:datcao/share/import.dart';

class ExpandRectangleButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const ExpandRectangleButton({Key key, this.text, this.onTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        audioCache.play('tab3.mp3');
        onTap();
      },
      child: Container(
        height: 55,
        width: deviceWidth(context),
        color: ptPrimaryColor(context),
        child: Center(
          child: Text(
            text,
            style: ptBigTitle().copyWith(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
