import 'dart:io';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/profile/change_password_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/utils/file_util.dart';

class UpdateProfilePage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(UpdateProfilePage()),
    );
  }

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  AuthBloc _authBloc;
  UserBloc _userBloc;
  bool uploadingAvatar = false;
  bool isLoading = false;
  TextEditingController _nameC = TextEditingController();
  TextEditingController _tagNameC = TextEditingController();
  TextEditingController _emailC = TextEditingController();
  TextEditingController _phoneC = TextEditingController();
  TextEditingController _facebookC = TextEditingController();
  TextEditingController _descriptionC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _userBloc = Provider.of(context);
      _nameC.text = _authBloc.userModel.name;
      _tagNameC.text = _authBloc.userModel.tagName;
      _emailC.text = _authBloc.userModel.email;
      _phoneC.text = _authBloc.userModel.phone;
      _facebookC.text = _authBloc.userModel.facebookUrl;
      _descriptionC.text = _authBloc.userModel.description;
    }
    super.didChangeDependencies();
  }

  Future _updateAvatar(String filePath) async {
    try {
      setState(() {
        uploadingAvatar = true;
      });
      final uint8 = (await File(filePath).readAsBytes());
      final thumbnail = await FileUtil.resizeImage(uint8, 200);
      final url = await FileUtil.uploadFireStorage(thumbnail?.path);
      setState(() {
        _authBloc.userModel.avatar = url;
        uploadingAvatar = false;
      });
      await _userBloc.updateUser(_authBloc.userModel);
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  Future _updateUserInfo() async {
    if (!_formKey.currentState.validate()) return;

    _authBloc.userModel.name = _nameC.text;
    _authBloc.userModel.tagName = _tagNameC.text;
    _authBloc.userModel.email = _emailC.text;
    _authBloc.userModel.phone = _phoneC.text;
    _authBloc.userModel.facebookUrl = _facebookC.text;
    _authBloc.userModel.description = _descriptionC.text;
    setState(() {
      isLoading = true;
    });
    final res = await _userBloc.updateUser(_authBloc.userModel);
    if (mounted)
      setState(() {
        isLoading = false;
      });
    if (res.isSuccess) {
      showToast('Cập nhật thành công', context, isSuccess: true);
      if (mounted) navigatorKey.currentState.maybePop();
    } else
      showToast(res.errMessage, context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ptSecondaryColor(context),
          appBar: AppBar2(
            'Cập nhật thông tin',
            actions: [
              SizedBox(
                width: 40,
                child: IconButton(
                    icon: Icon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    onPressed: _updateUserInfo),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SpacingBox(h: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: GestureDetector(
                    onTap: () {
                      imagePicker(context,
                          onImagePick: _updateAvatar,
                          onCameraPick: _updateAvatar);
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: CachedNetworkImageProvider(
                          _authBloc.userModel.avatar ?? ''),
                      child: uploadingAvatar
                          ? kLoadingSpinner
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Icon(
                                    MdiIcons.camera,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                SpacingBox(h: 2.5),
                Text(
                  AuthBloc.instance.userModel.name.toUpperCase(),
                  style: ptTitle(),
                ),
                SpacingBox(h: 2.5),
                Container(
                  width: deviceWidth(context),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildFormField(
                            context, 'Tên gọi', _nameC, Icons.person_outlined,
                            validator: TextFieldValidator.notEmptyValidator),
                        _buildFormField(context, 'Tên người dùng', _tagNameC,
                            Icons.tag_faces,
                            validator: TextFieldValidator.formalValidator,
                            hint: '@tennguoidung'),
                        _buildFormField(
                          context,
                          'Email',
                          _emailC,
                          Icons.email_outlined,
                        ),
                        _buildFormField(context, 'Số điện thoại', _phoneC,
                            Icons.phone_rounded,
                            readOnly: true),
                        _buildFormField(context, 'Facebook', _facebookC,
                            Icons.web_outlined),
                        _buildFormField(context, 'Giới thiệu ngắn',
                            _descriptionC, Icons.description_outlined,
                            maxLine: 4),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () => UpdatePasswordPage.navigate(),
                          child: Container(
                            height: 65,
                            margin: EdgeInsets.symmetric(vertical: 1),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                SizedBox(
                                  width: deviceWidth(context) / 3,
                                  child: Text(
                                    'Đổi mật khẩu',
                                    style: ptTitle()
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.chevron_right,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SpacingBox(h: 3),
                        // RoundedBtn(
                        //   height: 45,
                        //   text: 'Cập nhật',
                        //   onPressed: _updateUserInfo,
                        //   width: 140,
                        //   color: ptPrimaryColor(context),
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 15,
                        //     vertical: 8,
                        //   ),
                        // ),
                        // SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        if (isLoading) kLoadingSpinner,
      ],
    );
  }

  _buildFormField(BuildContext context, String text,
          TextEditingController controller, IconData icon,
          {int maxLine,
          bool readOnly = false,
          Function validator,
          String hint}) =>
      // Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   child: Container(
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(3),
      //           color: ptBackgroundColor(context)),
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
      //         child: TextField(
      //           maxLines: maxLine,
      //           controller: controller,
      //           decoration:
      //               InputDecoration(border: InputBorder.none, hintText: text),
      //         ),
      //       )),
      // );
      Container(
        height: 65,
        margin: EdgeInsets.symmetric(vertical: 0.8),
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              icon,
              size: 24,
            ),
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: deviceWidth(context) / 3,
              child: Text(
                text,
                style: ptTitle().copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            new Expanded(
              flex: 3,
              child: new Directionality(
                textDirection: TextDirection.rtl,
                child: TextFormField(
                  maxLines: null,
                  validator: validator,
                  readOnly: readOnly,
                  controller: controller,
                  textAlign: TextAlign.start,
                  style: ptTitle().copyWith(fontWeight: FontWeight.w400),
                  decoration:
                      new InputDecoration.collapsed(hintText: hint ?? '$text'),
                ),
              ),
            ),
          ],
        ),
      );
}
