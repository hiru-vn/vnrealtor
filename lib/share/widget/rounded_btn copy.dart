import 'package:vnrealtor/share/import.dart';

class RoundedBtn extends StatelessWidget {
  final Color color;
  final String text;
  final Function onPressed;
  final bool hasBorder;
  final double height;
  final EdgeInsets padding;
  final double width;

  const RoundedBtn(
      {Key key,
      this.color,
      this.padding,
      this.width,
      this.height,
      this.text,
      this.onPressed,
      this.hasBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? deviceWidth(context) / 2.1,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: hasBorder
            ? Border.all(color: ptPrimaryColor(context), width: 2)
            : null,
      ),
      child: Material(
        color: color ?? ptSecondaryColor(context),
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          splashColor: ptPrimaryColor(context),
          borderRadius: BorderRadius.circular(30),
          onTap: onPressed,
          child: Container(
            padding: padding ?? EdgeInsets.zero,
            child: Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  text,
                  style: TextStyle(
                      color: color != ptPrimaryColor(context)
                          ? ptPrimaryColor(context)
                          : Colors.white,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
