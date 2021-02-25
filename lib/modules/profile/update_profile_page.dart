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
  TextEditingController _emailC = TextEditingController();
  TextEditingController _phoneC = TextEditingController();
  TextEditingController _facebookC = TextEditingController();

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
      _userBloc = Provider.of(context);
      _nameC.text = _authBloc.userModel.name;
      _emailC.text = _authBloc.userModel.email;
      _phoneC.text = _authBloc.userModel.phone;
      // _facebookC.text = _authBloc.userModel.
    }
    super.didChangeDependencies();
  }

  Future _updateAvatar(String filePath) async {
    try {
      setState(() {
        uploadingAvatar = true;
      });
      final url = await FileUtil.uploadFireStorage(File(filePath));
      setState(() {
        _authBloc.userModel.avatar = url;
        uploadingAvatar = false;
      });
      
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  Future _updateUserInfo() async {
    _authBloc.userModel.name = _nameC.text;
    _authBloc.userModel.email = _emailC.text;
    _authBloc.userModel.phone = _phoneC.text;
    setState(() {
      isLoading = true;
    });
    final res = await _userBloc.updateUser(_authBloc.userModel);
    setState(() {
      isLoading = false;
    });
    if (res.isSuccess) {
      showToast('Cập nhật thành công', context, isSuccess: true);
    } else
      showToast(res.errMessage, context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar2('Cập nhật thông tin'),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SpacingBox(h: 3),
                ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: GestureDetector(
                    onTap: () {
                      imagePicker(context,
                          onImagePick: _updateAvatar,
                          onCameraPick: _updateAvatar);
                    },
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          NetworkImage(_authBloc.userModel.avatar ?? ''),
                      child: uploadingAvatar
                          ? kLoadingSpinner
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                child: Center(
                                  child: Icon(
                                    MdiIcons.camera,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                SpacingBox(h: 2),
                Container(
                  width: deviceWidth(context),
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      _buildFormField(context, 'Tên người dùng', _nameC),
                      SizedBox(height: 10),
                      _buildFormField(context, 'Email', _emailC),
                      SizedBox(height: 10),
                      _buildFormField(context, 'Số điện thoại', _phoneC),
                      SizedBox(height: 10),
                      _buildFormField(context, 'Facebook', _facebookC),
                      SizedBox(height: 10),
                      _buildFormField(context, 'Giới thiệu ngắn', _facebookC, maxLine: 4),
                      SpacingBox(h: 3),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RoundedBtn(
                              height: 45,
                              text: 'Cập nhật',
                              onPressed: _updateUserInfo,
                              width: 140,
                              color: ptPrimaryColor(context),
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                            ),
                            RoundedBtn(
                              height: 45,
                              text: 'Đổi mật khẩu',
                              onPressed: () async {
                                UpdatePasswordPage.navigate();
                              },
                              width: 140,
                              color: Colors.blue[300],
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
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
          TextEditingController controller, {int maxLine}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: ptBackgroundColor(context)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              child: TextField(
                maxLines: maxLine,
                controller: controller,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: text),
              ),
            )),
      );
}
