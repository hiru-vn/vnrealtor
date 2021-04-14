import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';

class ItemInfoPage extends StatelessWidget {
  final String image;
  final String title;
  const ItemInfoPage({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: 40,
          ),
          widthSpace(15),
          title != null
              ? Text(
                  title,
                  style: ptButton().copyWith(color: AppColors.mainColor, fontWeight: FontWeight.w400),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
