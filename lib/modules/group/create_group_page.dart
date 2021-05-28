import 'package:datcao/modules/bloc/group_bloc.dart';
import 'package:datcao/modules/inbox/google_map_widget.dart';
import 'package:datcao/modules/post/pick_coordinates.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(CreateGroupPage()));
  }

  CreateGroupPage({Key key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  GroupBloc _groupBloc;
  TextEditingController _nameC = TextEditingController();
  bool _isPrivate = false;
  TextEditingController _descriptionC = TextEditingController();
  String _cover;
  TextEditingController _addressC = TextEditingController();
  LatLng _position;
  bool _isUpload = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    if (_groupBloc == null) {
      _groupBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  _createGroup() async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    showWaitingDialog(context);

    final res = await _groupBloc.createGroup(
        _nameC.text,
        _isPrivate,
        _descriptionC.text,
        _cover,
        _addressC.text,
        _position?.latitude,
        _position?.longitude);

    navigatorKey.currentState.maybePop();
    if (res.isSuccess) {
      showToast('Tạo nhóm thành công', context, isSuccess: true);
      navigatorKey.currentState.maybePop();
    } else {
      showToast(res.errMessage, context);
    }
  }

  _pickImageCover() {
    onCustomPersionRequest(
        permission: Permission.photos,
        onGranted: () {
          ImagePicker.pickImage(source: ImageSource.gallery)
              .then((value) async {
            if (value == null) return;
            setState(() {
              _isUpload = true;
            });
            final res = await FileUtil.uploadFireStorage(value.path);
            setState(() {
              _cover = res;
              _isUpload = false;
            });
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptSecondaryColor(context),
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Tạo nhóm',
        textColor: ptPrimaryColor(context),
        automaticallyImplyLeading: true,
        actions: [
          Center(
            child: FlatButton(
                color: ptPrimaryColor(context),
                onPressed: _createGroup,
                child: Text(
                  'Tạo',
                  style: ptTitle().copyWith(color: Colors.white),
                )),
          ),
          SizedBox(width: 17)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tên nhóm', style: ptTitle()),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 2,
                    controller: _nameC,
                    validator: TextFieldValidator.notEmptyValidator,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text('Quyền riêng tư', style: ptTitle()),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: DropdownButtonFormField(
                    items: [
                      DropdownMenuItem(
                          child: Text('Công khai'), value: 'public'),
                      DropdownMenuItem(
                          child: Text('Nhóm kín'), value: 'private')
                    ],
                    onChanged: (val) {
                      if (val == 'public') {
                        _isPrivate = false;
                      } else {
                        _isPrivate = true;
                      }
                    },
                    validator: TextFieldValidator.notEmptyValidator,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text('Mô tả', style: ptTitle()),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TextFormField(
                    minLines: 4,
                    maxLines: 4,
                    validator: TextFieldValidator.notEmptyValidator,
                    controller: _descriptionC,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: ptSmall().copyWith(color: Colors.black38),
                        hintText:
                            'Mô tả nhóm giúp mọi người biết nhiều hơn về nhóm của bạn'),
                  ),
                ),
                SizedBox(height: 15),
                Text('Ảnh bìa', style: ptTitle()),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: _pickImageCover,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4)),
                    height: 136,
                    width: double.infinity,
                    child: _isUpload
                        ? kLoadingSpinner
                        : (_cover == null
                            ? Center(
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: ptSecondaryColor(context),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: Icon(Icons.photo_camera_back),
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: _cover, fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(height: 15),
                Text('Địa điểm', style: ptTitle()),
                SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: TextFormField(
                    minLines: 2,
                    maxLines: 2,
                    validator: TextFieldValidator.notEmptyValidator,
                    controller: _addressC,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: ptSmall().copyWith(color: Colors.black38),
                      hintText: 'Nhập địa điểm',
                    ),
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    PickCoordinates.navigate(hasPolygon: false).then((value) {
                      if (value == null) return;
                      _position = value[0];
                    });
                  },
                  child: Row(children: [
                    Icon(MdiIcons.googleMaps),
                    SizedBox(width: 10),
                    Text('Đánh dấu trên bản đồ', style: ptBody()),
                  ]),
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
