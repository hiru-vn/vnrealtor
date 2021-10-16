import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';

class InfoSocialPageCreatePage extends StatefulWidget {
  final PageController? pageController;

  const InfoSocialPageCreatePage({
    this.pageController,
  });

  @override
  _InfoSocialPageCreatePageState createState() =>
      _InfoSocialPageCreatePageState();
}

class _InfoSocialPageCreatePageState extends State<InfoSocialPageCreatePage> {
  final _formKey = GlobalKey<FormState>();

  PageController? get _pageController => widget.pageController;

  PagesBloc? _pagesBloc;

  @override
  void didChangeDependencies() {
    if (_pagesBloc == null) {
      _pagesBloc = Provider.of<PagesBloc>(context);
    }
    super.didChangeDependencies();
  }

  void _nextPage() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).requestFocus(FocusNode());
    _pageController!.nextPage(
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                          'Địa chỉ hiện tại',
                          _pagesBloc!.currentAddress,
                          (val) => _pagesBloc!.currentAddress = val,
                          validator: TextFieldValidator.notEmptyValidator),
                      heightSpace(20),
                      _buildTextField('Website', _pagesBloc!.website,
                          (val) => _pagesBloc!.website = val,
                          validator: TextFieldValidator.notEmptyValidator),
                      heightSpace(20),
                      _buildTextField('Số điện thoại', _pagesBloc!.phone,
                          (val) => _pagesBloc!.phone = val,
                          type: TextInputType.phone,
                          validator: TextFieldValidator.phoneValidator),
                      heightSpace(20),
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
      ],
    );
  }


  Widget _itemTileTextField(String text) => Container(
        child: Text(
          text,
          style: ptBigTitle().copyWith(fontWeight: FontWeight.w600),
        ),
      );

  Widget _itemTextField({TextEditingController? controller, String? hintText}) =>
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

  _buildTextField(String hint, String? initialValue, Function(String) onChange,
          {TextInputType type = TextInputType.text,
          Function(String)? validator}) =>
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
                validator: validator as String? Function(String?)?,
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
