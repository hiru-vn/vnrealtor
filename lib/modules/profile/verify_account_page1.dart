import 'package:vnrealtor/modules/bloc/verification_bloc.dart';
import 'package:vnrealtor/modules/profile/verify_account_page2.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vnrealtor/utils/file_util.dart';

class VertifyAccountPage1 extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(VertifyAccountPage1()));
  }

  @override
  _VertifyAccountPage1State createState() => _VertifyAccountPage1State();
}

class _VertifyAccountPage1State extends State<VertifyAccountPage1> {
  VerificationBloc _verificationBloc;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_verificationBloc == null) {
      _verificationBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptBackgroundColor(context),
      appBar: AppBar2('Xác minh nhà môi giới'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingBox(h: 3),
            SizedBox(
              width: 90,
              child: Image.asset('assets/image/verify.png'),
            ),
            SpacingBox(h: 3),
            Text(
              'Cung cấp thông tin cơ bản',
              style: ptBigTitle(),
            ),
            SpacingBox(h: 2),
            SizedBox(
              width: deviceWidth(context) / 1.3,
              child: Text(
                'Chúng tôi cần ảnh để đối chiếu với thông tin cá nhân mà bạn cung cấp',
                style: ptBigBody().copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
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
                        'Nhập đầy đủ họ tên (có dấu)',
                        _verificationBloc.name,
                        (val) => _verificationBloc.name = val,
                        validator: TextFieldValidator.notEmptyValidator),
                    SizedBox(height: 15),
                    _buildDatePickField(
                        'Ngày sinh',
                        _verificationBloc.dateOfBirth,
                        (val) => _verificationBloc.dateOfBirth = val,
                        validator: TextFieldValidator.notEmptyValidator),
                    SizedBox(height: 15),
                    _buildDatePickField(
                        'Ngày cấp',
                        _verificationBloc.dateOfIssue,
                        (val) => _verificationBloc.dateOfIssue = val,
                        validator: TextFieldValidator.notEmptyValidator),
                    SizedBox(height: 15),
                    _buildTextField(
                        'Nơi cấp (Ví dụ: Hà Nội)',
                        _verificationBloc.placeOfIssue,
                        (val) => _verificationBloc.placeOfIssue = val,
                        validator: TextFieldValidator.notEmptyValidator),
                    SizedBox(height: 15),
                    _buildPictureCollect(),
                    SizedBox(height: 25),
                    RoundedBtn(
                      height: 45,
                      text: 'Tiếp theo',
                      onPressed: () {
                        if (_verificationBloc.imageFront == null) {
                          showToast('Cần thêm ảnh CMND', context);
                        }
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        FocusScope.of(context).requestFocus(FocusNode());
                        VertifyAccountPage2.navigate();
                      },
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

  _buildDatePickField(String hint, String value, Function(String) onChange,
      {Function(String) validator}) {
    TextEditingController controller = TextEditingController(
        text: Formart.formatToDate(DateTime.tryParse(value ?? '')));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25)
                .copyWith(right: 10),
            child: TextFormField(
              controller: controller,
              validator: validator,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 5475)),
                  lastDate: DateTime.now(),
                ).then((value) => onChange(value.toIso8601String()));
              },
              readOnly: true,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  suffixIconConstraints: BoxConstraints(maxHeight: 30),
                  suffixIcon: Icon(Icons.calendar_today,
                      color: ptPrimaryColor(context))),
            ),
          )),
    );
  }

  _buildPictureCollect() => Container(
        height: 180,
        width: deviceWidth(context),
        child: Stack(children: [
          if (_verificationBloc.imageFront != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.network(_verificationBloc.imageFront),
            ),
          Positioned(
            top: 15,
            left: 25,
            right: 25,
            child: DottedBorder(
              color: Colors.black54,
              radius: Radius.circular(20),
              strokeWidth: 1,
              dashPattern: [8, 6],
              child: GestureDetector(
                onTap: () => onCustomPersionRequest(
                    permission: Permission.camera,
                    onGranted: () {
                      ImagePicker.pickImage(source: ImageSource.camera)
                          .then((value) async {
                        if (value == null) return;
                        final url = await FileUtil.uploadFireStorage(value);
                        _verificationBloc.imageFront = url;
                        setState(() {});
                      });
                    }),
                child: Container(
                  height: 160,
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ptPrimaryColor(context),
                        ),
                        child: Center(
                          child: Icon(
                            MdiIcons.camera,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Mở camera',
                        style: ptBody().copyWith(
                            color: (_verificationBloc.imageFront != null)
                                ? Colors.white
                                : Colors.black54),
                      )
                    ],
                  )),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                color: Colors.white,
                padding: EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    'Ảnh chứng minh nhân dân/ Hộ chiếu',
                    style: ptTitle().copyWith(color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
        ]),
      );
}
