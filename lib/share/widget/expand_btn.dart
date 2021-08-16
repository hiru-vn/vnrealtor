import 'package:datcao/share/import.dart';

class ExpandBtn extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color;
  final Color borderColor;
  final Color textColor;
  final double height;
  final double width;
  final int elevation;
  final double borderRadius;
  final bool isLoading;

  const ExpandBtn(
      {Key key,
      @required this.text,
      @required this.onPress,
      this.color,
      this.textColor,
      this.borderRadius,
      this.elevation,
      this.borderColor,
      this.isLoading = false,
      this.height,
      this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 45,
      child: GestureDetector(
        // elevation: elevation?.toDouble() ?? 5,

        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [ptMainColor(), ptSecondColor()],
              ),
              borderRadius: BorderRadius.circular(10)),
          child: isLoading
              ? kLoadingSpinner
              : Center(
                  child: Text(
                    text,
                    style:
                        ptButton().copyWith(color: textColor ?? Colors.white),
                  ),
                ),
        ),
      ),
    );
  }
}

class FacebookBtn extends StatelessWidget {
  final Function onPress;

  const FacebookBtn({Key key, @required this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: HexColor('#7583ca'),
        onPressed: onPress,
        child: Row(
          children: [
            SizedBox(width: 5),
            SizedBox(
              width: 35,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/image/facebook.png'),
              ),
            ),
            Expanded(
              child: Text(
                'Đăng nhập bằng Facebook',
                style: ptTitle().copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleBtn extends StatelessWidget {
  final Function onPress;

  const GoogleBtn({Key key, @required this.onPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white.withOpacity(0.98),
        onPressed: onPress,
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/image/google.png'),
              ),
            ),
            Expanded(
              child: Text(
                'Đăng nhập bằng Google',
                style: ptTitle().copyWith(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
