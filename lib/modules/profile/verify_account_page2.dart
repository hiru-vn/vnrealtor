import 'package:vnrealtor/modules/bloc/verification_bloc.dart';
import 'package:vnrealtor/share/import.dart';

class VertifyAccountPage2 extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(VertifyAccountPage2(),
          transitionBuilder: transitionRightBuilder),
    );
  }

  @override
  _VertifyAccountPage2State createState() => _VertifyAccountPage2State();
}

class _VertifyAccountPage2State extends State<VertifyAccountPage2> {
  VerificationBloc _verificationBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_verificationBloc == null) {
      _verificationBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  Future _submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_formKey.currentState.validate()) return;
    showSimpleLoadingDialog(context);
    final res = await _verificationBloc.createVerification();
    await navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      showToast('Gửi yêu cầu xác minh thành công', context, isSuccess: true);
      await navigatorKey.currentState.maybePop();
      await navigatorKey.currentState.maybePop();
    } else {
      showToast(res.errMessage, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2('Xác minh nhà môi giới'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingBox(h: 3),
            SizedBox(
              width: deviceWidth(context) / 1.3,
              child: Text(
                'Cập nhật thêm 1 số thông tin là bạn đã hoàn tất!',
                textAlign: TextAlign.center,
                style: ptBigTitle(),
              ),
            ),
            SpacingBox(h: 3),
            Container(
              width: deviceWidth(context),
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                        'Địa chỉ hiện tại',
                        _verificationBloc.currentAddress,
                        (val) => _verificationBloc.currentAddress = val,
                        validator: TextFieldValidator.notEmptyValidator),
                    SizedBox(height: 15),
                    _buildTextField('Số điện thoại', _verificationBloc.phone,
                        (val) => _verificationBloc.phone = val,
                        type: TextInputType.phone,
                        validator: TextFieldValidator.phoneValidator),
                    SizedBox(height: 15),
                    _buildTextField(
                        'Website (nếu có)',
                        _verificationBloc.website,
                        (val) => _verificationBloc.website = val),
                    SizedBox(height: 15),
                    _buildTextField(
                        'Mạng xã hội (FB) (nếu có)',
                        _verificationBloc.socialNetwork,
                        (val) => _verificationBloc.socialNetwork = val),
                    SpacingBox(h: 5),
                    RoundedBtn(
                      height: 45,
                      text: 'Hoàn tất',
                      onPressed: _submit,
                      width: 150,
                      color: ptPrimaryColor(context),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTextField(String hint, String initialValue, Function(String) onChange,
          {TextInputType type = TextInputType.text,
          Function(String) validator}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
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
                ),
              ),
            )),
      );
}
