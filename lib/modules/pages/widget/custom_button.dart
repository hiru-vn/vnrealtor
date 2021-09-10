import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/activity_indicator.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String image;
  final String imageSvg;
  final double sizeSvg;
  final bool isLoading;
  final double size;
  final VoidCallback callback;
  final Color color;
  final TextStyle style;
  const CustomButton(
      {this.title,
      this.image,
      this.imageSvg,
      this.isLoading = false,
      this.callback,
      this.size,
      this.color,
      this.sizeSvg,
      this.style});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? double.infinity,
      height: size ?? 45,
      child: FlatButton(
          // elevation: elevation?.toDouble() ?? 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
          color: color ?? ptPrimaryColorLight(context),
          onPressed: callback,
          child: isLoading
              ? SizedBox(
                  child: ActivityIndicator(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    image != null
                        ? Image.asset(
                            image,
                            width: 24,
                          )
                        : const SizedBox(),
                    imageSvg != null
                        ? Container(
                            width: sizeSvg ?? 25,
                            height: sizeSvg ?? 25,
                            child: SvgPicture.asset(
                              imageSvg,
                              color: Theme.of(context).textSelectionTheme.cursorColor,
                              semanticsLabel: imageSvg,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const SizedBox(),
                    widthSpace(10),
                    Text(
                      title,
                      style: style ??
                          ptButton()
                              .copyWith(color: Theme.of(context).textSelectionTheme.cursorColor),
                    )
                  ],
                )),
    );
  }
}
