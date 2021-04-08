import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/resources/styles/images.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChooseImageCreatePage extends StatefulWidget {
  @override
  _ChooseImageCreatePageState createState() => _ChooseImageCreatePageState();
}

class _ChooseImageCreatePageState extends State<ChooseImageCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _buildHeader(),
              Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: [_buildCoverImage(), _buildAvatarImage()],
              ),
            ],
          ),
          _itemButton(),
          heightSpace(10),
        ],
      ),
    );
  }

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thêm hình ảnh',
              style: ptBigTitle(),
            ),
            heightSpace(10),
            Text(
              '(Hình ảnh này sẽ xuất hiện trong phần kết quả tìm kiếm)',
              style: ptBigBody(),
            ),
          ],
        ),
      );

  Widget _buildCoverImage() => Container(
        child: Container(
          color: AppColors.backgroundLightColor,
          height: deviceWidth(context) / 1.5,
          child: _itemIconTitle('Thêm ảnh bìa'),
        ),
      );

  Widget _itemIconTitle(String title) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: FaIcon(
              FontAwesomeIcons.plus,
              size: 15,
              color: AppColors.mainColor,
            ),
          ),
          widthSpace(10),
          Text(
            title,
            style: ptBigTitle().copyWith(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      );

  Widget _buildAvatarImage() => Positioned(
        bottom: -50,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 155,
                height: 155,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              Center(
                child: Container(
                  width: 145,
                  height: 145,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.backgroundLightColor, width: 3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: new BoxDecoration(
                    color: AppColors.backgroundLightColor,
                    shape: BoxShape.circle,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: FaIcon(
                          FontAwesomeIcons.plus,
                          size: 15,
                          color: AppColors.mainColor,
                        ),
                      ),
                      widthSpace(10),
                      Container(
                        width: deviceWidth(context) * 0.2,
                        child: Text(
                          "Thêm ảnh đại diện ",
                          style: ptBigTitle().copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );


  Widget _itemButton() => Padding(
    padding: const EdgeInsets.all(10),
    child: ExpandBtn(
      elevation: 0,
      text: 'Hoàn tất',
      borderRadius: 5,
      onPress: () {

      },
      color: AppColors.buttonPrimaryColor,
      height: 45,
      textColor: Colors.white,
    ),
  );
}
