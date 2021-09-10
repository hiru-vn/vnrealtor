import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemInfoPage extends StatelessWidget {
  final String image;
  final String title;
  const ItemInfoPage({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: ptPrimaryColorLight(context),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  image,
                  color: Theme.of(context).textSelectionTheme.cursorColor,
                  semanticsLabel: image,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          widthSpace(15),
          title != null
              ? Text(
                  title,
                  style: ptButton().copyWith(
                      color: Theme.of(context).textSelectionTheme.cursorColor,
                      fontWeight: FontWeight.w400),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
