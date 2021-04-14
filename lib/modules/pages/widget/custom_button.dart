import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/activity_indicator.dart';
import 'package:datcao/share/widget/base_widgets.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final String image;
  final bool isLoading;
  final double size;
  final VoidCallback callback;
  const CustomButton(
      {this.title,
      this.image,
      this.isLoading = false,
      this.callback,
      this.size});

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
          color: AppColors.backgroundLightColor,
          onPressed: callback,
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: ActivityIndicator(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      image,
                      width: 24,
                    ),
                    widthSpace(10),
                    Text(
                      title,
                      style: ptButton().copyWith(color: AppColors.mainColor),
                    )
                  ],
                )),
    );
  }
}
