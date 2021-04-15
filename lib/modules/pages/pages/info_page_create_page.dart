import 'package:datcao/modules/pages/blocs/create_page_bloc.dart';
import 'package:datcao/modules/pages/widget/listItemTags.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/function/function.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/activity_indicator.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InfoPageCreatePage extends StatefulWidget {
  final PageController pageController;
  final TextEditingController nameController;
  final TextEditingController describeController;
  final TextEditingController categoriesController;

  const InfoPageCreatePage(
      {this.pageController,
      this.nameController,
      this.describeController,
      this.categoriesController});

  @override
  _InfoPageCreatePageState createState() => _InfoPageCreatePageState();
}

class _InfoPageCreatePageState extends State<InfoPageCreatePage> {
  final _formKey = GlobalKey<FormState>();

  PageController get _pageController => widget.pageController;

  TextEditingController get _nameC => widget.nameController;
  TextEditingController get _describeC => widget.describeController;
  TextEditingController get _categoriesC => widget.categoriesController;

  CreatePageBloc _createPageBloc;

  @override
  void didChangeDependencies() {
    if (_createPageBloc == null) {
      _createPageBloc = Provider.of<CreatePageBloc>(context);
      _initData();
    }
    super.didChangeDependencies();
  }

  _onAddCategory(String val) => _createPageBloc.addSelectedCategories(val);

  _initData() async {
    await _createPageBloc.getAllCategories();
  }

  void _nextPage() {
    if (_nameC.text.trim() == '') {
      showToast('Tên trang không được để trống', context);
      return;
    }

    if (_describeC.text.trim() == '') {
      showToast('Nội dung không được để trống', context);
      return;
    }

    if (_createPageBloc.listCategoriesId.isEmpty) {
      showToast('Vui lòng chọn hạng mục', context);
      return;
    }

    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
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
                        title: 'Nhập tên trang ',
                        controller: _describeC,
                        hintText: 'Mô tả trang ',
                      ),
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
          ),
        ),
        if (_createPageBloc.isLoading)
          Container(
            height: deviceHeight(context),
            color: ptSecondaryColor(context),
            child: ActivityIndicator(),
          )
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
            if (_createPageBloc.listCategoriesSelected.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListItemTags(
                  title: "",
                  list: _createPageBloc.listCategoriesSelected,
                  isEnableRemove: true,
                  onClickAt: _createPageBloc.removeCategory,
                  alignment: WrapAlignment.end,
                ),
              ),
            _itemAutoFillText(
                controller: _categoriesC,
                hintText: 'Tìm kiếm hạng mục',
                onSubmit: (val) => _onAddCategory(val))
          ],
        ),
      );

  _itemAutoFillText({
    String hintText,
    List<String> items,
    OnChange onSubmit,
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
            controller.clear();
          },
          noItemsFoundBuilder: (context) => _itemEmpty(),
          itemBuilder: (context, item) => ListTile(
            title: Text(
              item,
              style: ptBody(),
            ),
          ),
          suggestionsCallback: (val) async {
            var list = [];
            if (controller.text.isNotEmpty) {
              list = await _createPageBloc.getCategoriesByKeyword(
                  filter: GraphqlFilter(search: val, order: '{createdAt: -1}'));
            }
            return list.isNotEmpty ? list : [];
          },
          hideOnEmpty: true,
          autoFlipDirection: true,
          hideOnError: true,
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
              hintText: hintText,
              hintStyle: ptBigBody().copyWith(color: AppColors.greyHint),
            ),
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
          onPress: () => _nextPage(),
          color: AppColors.buttonPrimaryColor,
          height: 45,
          textColor: Colors.white,
        ),
      );

  _buildTextField(String hint, String initialValue, Function(String) onChange,
          {TextInputType type = TextInputType.text,
          Function(String) validator}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _itemTileTextField(hint),
          heightSpace(15),
          Material(
            // elevation: 4,
            // borderRadius: BorderRadius.circular(10),
            color: ptSecondaryColor(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: TextFormField(
                validator: validator,
                keyboardType: type,
                initialValue: initialValue,
                onChanged: onChange,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: ptBigBody().copyWith(color: AppColors.greyHint)),
              ),
            ),
          ),
        ],
      );
}
