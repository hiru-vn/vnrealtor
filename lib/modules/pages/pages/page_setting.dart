import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/widget/custom_button.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:datcao/share/import.dart';
import 'dart:async';

class PageSetting extends StatefulWidget {
  final PagesBloc pageBloc;
  const PageSetting({Key key, this.pageBloc}) : super(key: key);

  static Future navigate(PagesBloc pageBloc) {
    return navigatorKey.currentState.push(
      pageBuilder(
        PageSetting(
          pageBloc: pageBloc,
        ),
      ),
    );
  }

  @override
  _PageSettingState createState() => _PageSettingState();
}

class _PageSettingState extends State<PageSetting> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  TextEditingController _nameC = new TextEditingController();
  TextEditingController _webC = new TextEditingController();
  TextEditingController _phoneC = new TextEditingController();
  TextEditingController _addressC = new TextEditingController();
  TextEditingController _descriptionC = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isUpdateLoading = false;

  PagesBloc get _pageBloc => widget.pageBloc;

  @override
  void initState() {
    _nameC.text = _pageBloc.pageDetail.name;
    _webC.text = _pageBloc.pageDetail.website;
    _phoneC.text = _pageBloc.pageDetail.phone;
    _addressC.text = _pageBloc.pageDetail.address;
    _descriptionC.text = _pageBloc.pageDetail.description;
    super.initState();
  }

  Future _updateInfo() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      isUpdateLoading = true;
    });

    var res;
    res = await _pageBloc.updatePage(
        id: _pageBloc.pageDetail.id,
        avatar: _pageBloc.pageDetail.avartar,
        cover: _pageBloc.pageDetail.coverImage,
        name: _nameC.text,
        description: _descriptionC.text,
        categoryIds: _pageBloc.pageDetail.categoryIds,
        address: _addressC.text,
        phone: _phoneC.text,
        email: "",
        website: _webC.text);
    if (res.isSuccess) {
      setState(() {
        isUpdateLoading = false;
      });
      showAlertDialog(context, 'Thông tin đã được cập nhật',
          navigatorKey: navigatorKey);
      _pageBloc.pageDetail.name = _nameC.text;
      _pageBloc.pageDetail.website = _webC.text;
      _pageBloc.pageDetail.address = _addressC.text;
      _pageBloc.pageDetail.phone = _phoneC.text;
      _pageBloc.pageDetail.description = _descriptionC.text;
      Future.delayed(Duration(seconds: 1), () => _pageBloc?.notifyListeners());
    } else {
      setState(() {
        isUpdateLoading = false;
      });
      navigatorKey.currentState.maybePop();
      showToast(res.errMessage, context);
    }
    Future.delayed(Duration(seconds: 1), () => _pageBloc?.notifyListeners());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondAppBar(
          title: 'Chỉnh sửa trang',
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _itemTileTextField("tên trang"),
                  heightSpace(15),
                  _itemInfoField(
                    controller: _nameC,
                    hintText: 'tên trang',
                  ),
                  heightSpace(25),
                  _itemTileTextField("Sửa tên website"),
                  heightSpace(15),
                  _itemInfoField(
                    controller: _webC,
                    hintText: 'Sửa tên website',
                  ),
                  heightSpace(25),
                  _itemTileTextField("Số điện thoại"),
                  heightSpace(15),
                  _itemInfoField(
                    controller: _phoneC,
                    hintText: 'Số điện thoại',
                  ),
                  heightSpace(25),
                  _itemTileTextField("địa chỉ"),
                  heightSpace(15),
                  _itemInfoField(
                    controller: _descriptionC,
                    hintText: 'địa chỉ',
                  ),
                  heightSpace(25),
                  _buildButtonSave(_updateInfo)
                ],
              ),
            ),
          ),
        ));
  }

  Widget _itemTileTextField(String text) => Container(
        child: Text(
          text,
          style: ptBigTitle().copyWith(fontWeight: FontWeight.w600),
        ),
      );

  Widget _itemInfoField({TextEditingController controller, String hintText}) =>
      _itemTextField(controller: controller, hintText: hintText);

  Widget _itemTextField({TextEditingController controller, String hintText}) =>
      Material(
        elevation: 0,
        color: ptSecondaryColor(context),
        borderRadius: BorderRadius.circular(5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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

  Widget _buildButtonSave(VoidCallback action) => Container(
        width: deviceWidth(context),
        child: CustomButton(
          title: "Lưu ",
          isLoading: isUpdateLoading,
          color: AppColors.mainColor,
          style: ptTitle().copyWith(color: Colors.white),
          callback: action,
        ),
      );

  Widget _buildButtonDeletePage() => Container(
        child: CustomButton(),
      );
}
