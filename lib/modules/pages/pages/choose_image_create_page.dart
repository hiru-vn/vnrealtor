import 'package:datcao/modules/pages/blocs/create_page_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'dart:io';
import 'package:datcao/utils/file_util.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class ChooseImageCreatePage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController describeController;

  const ChooseImageCreatePage({this.nameController, this.describeController});

  @override
  _ChooseImageCreatePageState createState() => _ChooseImageCreatePageState();
}

class _ChooseImageCreatePageState extends State<ChooseImageCreatePage> {
  bool uploadingCover = false;

  TextEditingController get _nameC => widget.nameController;
  TextEditingController get _describeC => widget.describeController;

  CreatePageBloc _createPageBloc;
  PagesBloc _pagesBloc;


  @override
  void didChangeDependencies() {
    if (_createPageBloc == null) {
      _createPageBloc = Provider.of<CreatePageBloc>(context);
    }
    super.didChangeDependencies();
  }

  Future _createPage() async {
    try {
      _createPageBloc.isLoadingSubmitCreatePage = true;
      if (_createPageBloc.urlAvatar == null) {
        showToast('Vui lòng chọn ảnh đại diện của trang', context);
        return;
      }
      if (_createPageBloc.urlCover == null) {
        showToast('Vui lòng chọn ảnh bìa của trang', context);
        return;
      }

      final res = await _createPageBloc.createPage(
          _nameC.text.trim(),
          _describeC.text.trim(),
          _createPageBloc.urlAvatar,
          _createPageBloc.urlCover,
          _createPageBloc.listCategoriesId,
          _createPageBloc.currentAddress,
          _createPageBloc.website,
          _createPageBloc.phone);

      if (res.isSuccess) {
        _nameC.clear();
        _describeC.clear();
        _createPageBloc.urlAvatar = null;
        _createPageBloc.urlCover = null;
        _createPageBloc.currentAddress = null;
        _createPageBloc.website = null;
        _createPageBloc.phone = null;
        _createPageBloc.listCategoriesId = [];
        _createPageBloc.listCategoriesSelected = [];
        _pagesBloc.updateListPageCreate(res.data);
        PageDetail.navigate(res.data, isParamPageCreate: true);
      } else {
        print(res.errMessage);
        showToast(res.errMessage, context);
      }
    } catch (e) {} finally {
      _createPageBloc.isLoadingSubmitCreatePage = false;
    }
  }

  Future _updateCover(String filePath) async {
    try {
      _createPageBloc.isLoadingUploadCover = true;
      final compressImage = await _compressedFile(filePath);
      final uint8 = (await File(compressImage).readAsBytes());
      final thumbnail = await FileUtil.resizeImage(uint8, 360);
      final url = await FileUtil.uploadFireStorage(thumbnail?.path);
      _createPageBloc.isLoadingUploadCover = false;
      _createPageBloc.urlCover = url;
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  Future _updateAvatar(String filePath) async {
    try {
      _createPageBloc.isLoadingUploadAvatar = true;
      final compressImage = await _compressedFile(filePath);
      final uint8 = (await File(compressImage).readAsBytes());
      final thumbnail = await FileUtil.resizeImage(uint8, 120);
      final url = await FileUtil.uploadFireStorage(thumbnail?.path);
      _createPageBloc.isLoadingUploadAvatar = false;
      _createPageBloc.urlAvatar = url;
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  Future<String> _compressedFile(String path) async {
    var compressedFile =
        await FlutterNativeImage.compressImage(path, quality: 80);
    return compressedFile.path;
  }

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
          heightSpace(10),
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

  Widget _buildCoverImage() => GestureDetector(
        onTap: !_createPageBloc.isLoadingSubmitCreatePage
            ? () {
                imagePicker(context,
                    onImagePick: _updateCover, onCameraPick: _updateCover);
              }
            : null,
        child: Builder(
          builder: (BuildContext context) {
            if (_createPageBloc.urlCover != null)
              return Container(
                height: deviceWidth(context) / 1.5,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLightColor,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        _createPageBloc.urlCover ?? ''),
                  ),
                ),
              );
            return Container(
              color: AppColors.backgroundLightColor,
              height: deviceWidth(context) / 1.5,
              child: _createPageBloc.isLoadingUploadCover
                  ? kLoadingSpinner
                  : _itemIconTitle('Thêm ảnh bìa'),
            );
          },
        ),
      );

  Widget _buildAvatarImage() => Positioned(
        bottom: -70,
        child: GestureDetector(
          onTap: !_createPageBloc.isLoadingSubmitCreatePage
              ? () {
                  imagePicker(context,
                      onImagePick: _updateAvatar, onCameraPick: _updateAvatar);
                }
              : null,
          child: Builder(
            builder: (context) {
              if (_createPageBloc.urlAvatar != null) return _buildUrlAvatar();
              return Center(
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
                        child: _createPageBloc.isLoadingUploadAvatar
                            ? kLoadingSpinner
                            : Row(
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
              );
            },
          ),
        ),
      );

  Widget _buildUrlAvatar() => Center(
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
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        _createPageBloc.urlAvatar ?? ''),
                  ),
                ),
              ),
            )
          ],
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

  Widget _itemButton() => Padding(
        padding: const EdgeInsets.all(10),
        child: ExpandBtn(
          elevation: 0,
          text: 'Hoàn tất',
          borderRadius: 5,
          onPress: _createPage,
          isLoading: _createPageBloc.isLoadingSubmitCreatePage,
          color: AppColors.buttonPrimaryColor,
          height: 45,
          textColor: Colors.white,
        ),
      );
}
