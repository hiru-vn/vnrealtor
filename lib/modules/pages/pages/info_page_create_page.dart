import 'package:datcao/modules/pages/widget/listItemTags.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/function/function.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InfoPageCreatePage extends StatefulWidget {
  final PageController pageController;
  const InfoPageCreatePage({this.pageController});

  @override
  _InfoPageCreatePageState createState() => _InfoPageCreatePageState();
}

class _InfoPageCreatePageState extends State<InfoPageCreatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameC = TextEditingController(text: '');
  TextEditingController _describeC = TextEditingController(text: '');

  PageController get _pageController => widget.pageController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemInfoField(
                    title: 'Nhập tên trang',
                    controller: _nameC,
                    hintText: 'Tên trang '),
                heightSpace(20),
                _itemInfoField(
                    title: 'Nhập tên trang web',
                    controller: _describeC,
                    hintText: 'Mô tả trang '),
                heightSpace(20),
                _buildSelectCategory(),
              ],
            ),
          ),
        ),
        heightSpace(15),
        _itemButton(),
        heightSpace(15),
      ],
    );
  }

  Widget _itemInfoField(
          {String title, TextEditingController controller, String hintText}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _itemTileTextField(title),
          heightSpace(15),
          _itemTextField(controller: controller, hintText: hintText),
        ],
      );

  Widget _itemTileTextField(String text) => Container(
        child: Text(
          text,
          style: ptBigTitle().copyWith(fontWeight: FontWeight.w600),
        ),
      );

  Widget _itemTextField({TextEditingController controller, String hintText}) =>
      Material(
        elevation: 0,
        color: ptSecondaryColor(context),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          child: TextFormField(
            validator: TextFieldValidator.notEmptyValidator,
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: ptBigBody().copyWith(color: AppColors.greyHint)),
          ),
        ),
      );

  Widget _buildSelectCategory() => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _itemTileTextField('Chọn hạng mục'),
            heightSpace(15),
            _itemSearchCategory()
          ],
        ),
      );

  Widget _itemSearchCategory() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ptSecondaryColor(context),
          boxShadow: [
            BoxShadow(
              spreadRadius: 40,
              blurRadius: 40.0,
              offset: Offset(0, 10),
              color: Color.fromRGBO(0, 0, 0, 0.03),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListItemTags(
              title: "",
              list: ["BDS", "Chung Cư", "Nhà Đất"],
              isEnableRemove: true,
              onClickAt: null,
              alignment: WrapAlignment.end,
            ),
            heightSpace(10),
            _itemAutoFillText()
          ],
        ),
      );

  _itemAutoFillText({
    String hintText,
    List<String> items,
    OnChange onSubmit,
    int groupId,
    TextEditingController controller,
    Function(String) onValidate,
  }) =>
      MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: TypeAheadFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: onValidate,
          onSuggestionSelected: (val) {
            onSubmit(val);
            controller..text = "";
          },
          noItemsFoundBuilder: (context) => _itemEmpty(),
          itemBuilder: (context, item) => ListTile(
            title: Text(
              item,
              style: ptBody(),
            ),
          ),
          suggestionsCallback: (val) async {},
          hideOnEmpty: true,
          keepSuggestionsOnSuggestionSelected: true,
          autoFlipDirection: true,
          textFieldConfiguration: TextFieldConfiguration(
            maxLength: 255,
            controller: controller,
            style: ptBody(),
            onChanged: (val) => {},
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
              isDense: true,
              counterText: "",
              errorStyle: typeError(),
              hintText: 'Tìm kiếm hạng mục',
              hintStyle: ptBigBody().copyWith(color: AppColors.greyHint),
            ),
            onSubmitted: (val) {
              onSubmit(val);
              controller..text = "";
            },
          ),
        ),
      );

  Widget _itemEmpty() => Container(
        color: Colors.white,
      );

  Widget _itemButton() => Padding(
        padding: const EdgeInsets.all(10),
        child: ExpandBtn(
          elevation: 0,
          text: 'Tiếp theo',
          borderRadius: 5,
          onPress: () {
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          color: AppColors.buttonPrimaryColor,
          height: 45,
          textColor: Colors.white,
        ),
      );
}
