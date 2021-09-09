import 'dart:io';

import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/inbox/inbox_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_create_post.dart';
import 'package:datcao/modules/pages/pages/page_setting.dart';
import 'package:datcao/modules/pages/widget/custom_button.dart';
import 'package:datcao/modules/pages/widget/item_info_page.dart';
import 'package:datcao/modules/pages/widget/page_Detail_loading.dart';
import 'package:datcao/modules/post/post_widget.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/resources/styles/images.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/activity_indicator.dart';
import 'package:datcao/share/widget/base_widgets.dart';
import 'package:datcao/share/widget/load_more.dart';
import 'package:datcao/utils/file_util.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PageDetail extends StatefulWidget {
  final PagesCreate page;
  final bool isParamPageCreate;
  const PageDetail({Key key, this.page, this.isParamPageCreate = false})
      : super(key: key);

  static Future navigate(PagesCreate page, {bool isParamPageCreate = false}) {
    return navigatorKey.currentState.push(
      pageBuilder(
        PageDetail(
          page: page,
          isParamPageCreate: isParamPageCreate,
        ),
      ),
    );
  }

  @override
  _PageDetailState createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  AuthBloc _authBloc;
  PagesBloc _pagesBloc;

  PagesCreate get _pageState => widget.page;
  bool get _isParamPageCreate => widget.isParamPageCreate;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    if (_pagesBloc == null) {
      _pagesBloc = Provider.of<PagesBloc>(context);
      _getPageDetail();
      _getPostPage();
    }
    super.didChangeDependencies();
  }

  Future _getPageDetail() async {
    var res;
    _pagesBloc.pageDetail = null;
    if (_authBloc.userModel != null) {
      res = await _pagesBloc.getOnePage(_pageState.id);
    } else {
      res = await _pagesBloc.getOnePageGuess(_pageState.id);
    }
    if (res.isSuccess) {
      _pagesBloc.pageDetail = res.data;
      if (_authBloc.userModel != null)
        _pagesBloc.updatePageFollowed(_authBloc.userModel.id);
      _pagesBloc.isReceiveNotified = _pagesBloc.pageDetail?.isNoty;
    } else {
      navigatorKey.currentState.maybePop();
      showToast(res.errMessage, context);
    }
  }

  Future _getPostPage() async {
    if (_authBloc.userModel != null) {
      _getAllPostOfPage();
    } else {
      _getAllPostOfPageByGuess();
    }
  }

  Future<void> _getAllPostOfPage() async => await _pagesBloc.getPostsOfPage(
        filter: GraphqlFilter(
          filter: '{ pageId: "${_pageState.id}"}',
          order: "{updatedAt: -1}",
        ),
      );

  Future<void> _getAllPostOfPageByGuess() async =>
      await _pagesBloc.getPostsOfPageByGuess(
        filter: GraphqlFilter(
          filter: '{ pageId: "${_pageState.id}"}',
          order: "{updatedAt: -1}",
        ),
      );

  Future popUntilStep(int step, [dynamic params]) async {
    int count = 0;
    Navigator.popUntil(
      context,
      (route) => count++ == step,
    );
  }

  popScreen({dynamic params}) => Navigator.pop(context, params);

  Future _updateCover(String filePath) async {
    try {
      _pagesBloc.isLoadingUploadCover = true;
      final uint8 = (await File(filePath).readAsBytes());
      final thumbnail = await FileUtil.resizeImage(uint8, 360);
      final url = await FileUtil.uploadFireStorage(thumbnail?.path,
          path:
              "pages/coverImage_user_${AuthBloc.instance.userModel.id}/${DateTime.now().millisecondsSinceEpoch}");
      _pagesBloc.isLoadingUploadCover = false;
      _pagesBloc.pageDetail.coverImage = url;
      await _pagesBloc.updatePage(
          id: _pageState.id,
          avatar: _pagesBloc.pageDetail.avartar,
          cover: _pagesBloc.pageDetail.coverImage,
          name: _pagesBloc.pageDetail.name,
          description: _pagesBloc.pageDetail.description,
          categoryIds: _pagesBloc.pageDetail.categoryIds,
          address: _pagesBloc.pageDetail.address,
          phone: _pagesBloc.pageDetail.phone,
          email: "",
          website: _pagesBloc.pageDetail.website);
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  Future _updateAvatar(String filePath) async {
    try {
      _pagesBloc.isLoadingUploadAvatar = true;
      // final compressImage = await _compressedFile(filePath);
      final uint8 = (await File(filePath).readAsBytes());
      final thumbnail = await FileUtil.resizeImage(uint8, 120);
      final url = await FileUtil.uploadFireStorage(thumbnail?.path,
          path:
              "pages/avatar_user_${AuthBloc.instance.userModel.id}/${DateTime.now().millisecondsSinceEpoch}");
      _pagesBloc.isLoadingUploadAvatar = false;
      _pagesBloc.pageDetail.avartar = url;
      await _pagesBloc.updatePage(
        id: _pageState.id,
        avatar: _pagesBloc.pageDetail.avartar,
        cover: _pagesBloc.pageDetail.coverImage,
        name: _pagesBloc.pageDetail.name,
        description: _pagesBloc.pageDetail.description,
        categoryIds: _pagesBloc.pageDetail.categoryIds,
        address: _pagesBloc.pageDetail.address,
        phone: _pagesBloc.pageDetail.phone,
        email: "",
        website: _pagesBloc.pageDetail.website,
      );
    } catch (e) {
      showToast(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _pagesBloc.pagePostsScrollController = ScrollController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: SecondAppBar(
        title: _pagesBloc.pageDetail != null
            ? _pagesBloc.pageDetail.name
            : "Trang",
      ),
      body: Container(
        height: deviceHeight(context),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor.withOpacity(0.6),
        ),
        child: LoadMoreScrollView(
          scrollController: _pagesBloc.pagePostsScrollController,
          onLoadMore: () {
            // _postBloc.loadMoreNewFeed();
          },
          list: RefreshIndicator(
            color: ptPrimaryColor(context),
            onRefresh: () async {
              audioCache.play('tab3.mp3');
              // await Future.wait([
              //   _postBloc.getNewFeed(
              //       filter:
              //       GraphqlFilter(limit: 10, order: "{updatedAt: -1}")),
              //   _postBloc.getStoryFollowing()
              // ]);
              return;
            },
            child: SingleChildScrollView(
              controller: _pagesBloc.pagePostsScrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _pagesBloc.pageDetail != null
                      ? _buildHasData()
                      : PageDetailLoading(),
                  _buildListPostOfPage()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHasData() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !_pagesBloc.isLoadingUploadCover
              ? _buildBanner()
              : Container(
                  height: deviceWidth(context) / 2,
                  color: ptPrimaryColor(context),
                  child: Center(
                    child: ActivityIndicator(),
                  ),
                ),
          _buildHeader(),
          _buildInfoPage(),
        ],
      );

  Widget _buildBanner() => GestureDetector(
        onTap: _pagesBloc.pageDetail.isOwner
            ? () {
                audioCache.play('tab3.mp3');
                imagePicker(context,
                    onImagePick: _updateCover, onCameraPick: _updateCover);
              }
            : null,
        child: CachedNetworkImage(
          imageUrl: _pagesBloc.pageDetail.coverImage != null
              ? _pagesBloc.pageDetail.coverImage
              : "https://i.ibb.co/Zcx1Ms8/error-image-generic.png",
          imageBuilder: (context, imageProvider) => Container(
            height: deviceWidth(context) / 2,
            decoration: BoxDecoration(
              color: AppColors.backgroundLightColor,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => Container(
            height: deviceWidth(context) / 2,
            color: ptPrimaryColor(context),
            child: Center(
              child: ActivityIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: deviceWidth(context) / 2,
            color: ptPrimaryColor(context),
            child: Center(
              child: Icon(
                Icons.error,
                color: AppColors.mainColor,
              ),
            ),
          ),
        ),
      );

  Widget _buildHeader() => Container(
        decoration: BoxDecoration(
          color: ptPrimaryColor(context),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _itemHeaderInfo(),
                ),
                if (_authBloc.userModel != null)
                  if (!_pagesBloc.pageDetail.isOwner)
                    Flexible(
                      child: _itemButtonFollow(),
                    )
              ],
            ),
            if (_authBloc.userModel != null) heightSpace(25),
            if (_authBloc.userModel != null)
              !_pagesBloc.pageDetail.isOwner
                  ? _buildContainerButtonsToolMessage()
                  : _buildContainerButtonsToolCreatePost(_pageState),
            if (_authBloc.userModel != null) heightSpace(10),
          ],
        ),
      );

  Widget _itemHeaderInfo() => Row(
        children: [
          _pagesBloc.isLoadingUploadAvatar
              ? Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: ptPrimaryColor(context),
                  ),
                  child: Center(
                    child: ActivityIndicator(),
                  ),
                )
              : GestureDetector(
                  onTap: _pagesBloc.pageDetail.isOwner
                      ? () {
                          audioCache.play('tab3.mp3');
                          imagePicker(context,
                              onImagePick: _updateAvatar,
                              onCameraPick: _updateAvatar);
                        }
                      : null,
                  child: CachedNetworkImage(
                    imageUrl: _pagesBloc.pageDetail.avartar != null
                        ? _pagesBloc.pageDetail.avartar
                        : "https://i.ibb.co/Zcx1Ms8/error-image-generic.png",
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ptPrimaryColor(context),
                      ),
                      child: Center(
                        child: ActivityIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: ptPrimaryColor(context),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ),
                  ),
                ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    _pagesBloc.pageDetail.name,
                    style: ptTitle(),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 3),
              Text(
                _pagesBloc.pageDetail.category[0].name,
                style: ptSmall(),
              )
            ],
          )
        ],
      );

  Widget _itemButtonFollow() => ExpandBtn(
        onPress: () async {
          audioCache.play('tab3.mp3');
          if (_pagesBloc.isFollowed) {
            _pagesBloc.isFollowPageLoading = true;
            final res = await _pagesBloc.unFollowPage(_pageState.id);

            if (res.isSuccess) {
              _pagesBloc.removeItemOutOfListFollowPage(_pageState);
            } else {
              _pagesBloc.isFollowPageLoading = false;
              showToast(res.errMessage, context);
            }

            _pagesBloc.isFollowPageLoading = false;
          } else {
            _pagesBloc.isFollowPageLoading = true;
            final res = await _pagesBloc.followPage(_pageState.id);

            if (res.isSuccess) {
              _pagesBloc.addItemToListFollowPage(_pageState);
            } else {
              _pagesBloc.isFollowPageLoading = false;
              showToast(res.errMessage, context);
            }

            _pagesBloc.isFollowPageLoading = false;
          }
          await _pagesBloc.suggestFollow();
        },
        text: _pagesBloc.isFollowed ? "Bỏ theo dõi" : "Theo dõi",
      );

  Widget _buildContainerButtonsToolCreatePost(PagesCreate page) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _buildButtonCreatePost(page),
            ),
            widthSpace(20),
            _buildButtonSetting()
          ],
        ),
      );

  Widget _buildContainerButtonsToolMessage() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _buildButtonMessage(),
            ),
            widthSpace(20),
            _buildButtonBell(),
          ],
        ),
      );

  Widget _buildButtonMessage() => CustomButton(
        title: "Nhắn tin",
        imageSvg: AppImages.icPageMessage,
        callback: () async {
          showWaitingDialog(context);
          await InboxBloc.instance.navigateToChatWith(
              widget.page.owner.name,
              widget.page.avartar,
              DateTime.now(),
              widget.page.avartar,
              [
                AuthBloc.instance.userModel.id,
                widget.page.ownerId,
              ],
              [
                AuthBloc.instance.userModel.avatar,
                widget.page.avartar,
              ],
              pageName: widget.page.name,
              pageId: widget.page.id);
          closeLoading();
        },
      );

  Widget _buildButtonCreatePost(PagesCreate page) => CustomButton(
        title: "Tạo bài viết",
        imageSvg: AppImages.icCreatePost,
        callback: () => PageCreatePostPage.navigate(page),
      );

  Widget _buildButtonSetting() => GestureDetector(
        onTap: () => PageSetting.navigate(_pagesBloc),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: AppColors.backgroundLightColor,
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: AppColors.backgroundLightColor,
              ),
              child: SvgPicture.asset(
                AppImages.icSettingPage,
                color: AppColors.mainColor,
                semanticsLabel: 'icSettingPage',
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      );

  Widget _buildButtonBell() => GestureDetector(
        onTap: () async {
          audioCache.play('tab3.mp3');
          if (_pagesBloc.isReceiveNotified) {
            _pagesBloc.isReciveNotiPageLoading = true;
            final res = await _pagesBloc.unReceiveNotifyPage(_pageState.id);
            if (res.isSuccess) {
              _pagesBloc.isReceiveNotified = false;
            } else {
              _pagesBloc.isReciveNotiPageLoading = false;
              showToast(res.errMessage, context);
            }

            _pagesBloc.isReciveNotiPageLoading = false;
          } else {
            _pagesBloc.isReciveNotiPageLoading = true;
            final res = await _pagesBloc.receiveNotifyPage(_pageState.id);

            if (res.isSuccess) {
              _pagesBloc.isReceiveNotified = true;
            } else {
              _pagesBloc.isReciveNotiPageLoading = false;
              showToast(res.errMessage, context);
            }

            _pagesBloc.isReciveNotiPageLoading = false;
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: ptPrimaryColorLight(context),
              ),
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: ptPrimaryColorLight(context),
              ),
              child: _pagesBloc.isReciveNotiPageLoading
                  ? CircularProgressIndicator(
                      backgroundColor: Color(0xff293079),
                    )
                  : SvgPicture.asset(
                      _pagesBloc.isReceiveNotified
                          ? AppImages.icBellActivePage
                          : AppImages.icBellPage,
                      color: Theme.of(context).cursorColor,
                      semanticsLabel: 'Notify',
                      fit: BoxFit.contain,
                    ),
            )
          ],
        ),
      );

  Widget _buildInfoPage() => Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: ptPrimaryColor(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ItemInfoPage(
              image: AppImages.icFollower,
              title:
                  '${_pagesBloc.pageDetail.followers.length > 0 ? _pagesBloc.pageDetail.followers.length : 0} lượt follow',
            ),
            if (_pagesBloc.pageDetail.address != null)
              ItemInfoPage(
                image: AppImages.icLocation,
                title: _pagesBloc.pageDetail.address,
              ),
            if (_pagesBloc.pageDetail.phone != null)
              ItemInfoPage(
                image: AppImages.icPhone,
                title: _pagesBloc.pageDetail.phone,
              ),
            if (_pagesBloc.pageDetail.website != null)
              ItemInfoPage(
                image: AppImages.icSocial,
                title: _pagesBloc.pageDetail.website,
              )
          ],
        ),
      );

  Widget _buildListPostOfPage() => Container(
        child: Column(children: [
          if (_pagesBloc.isGetPostPageLoading) PostSkeleton(),
          if (_pagesBloc.listPagePost.isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Chưa có bài viết nào",
                  style: ptTitle().copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _pagesBloc.listPagePost.length,
            itemBuilder: (context, index) {
              final item = _pagesBloc.listPagePost[index];
              return PostWidget(item);
            },
          ),
          // if (_pagesBloc.isLoadMoreFeed && !_postBloc.isEndFeed)
          //   PostSkeleton(
          //     count: 1,
          //   ),
          SizedBox(
            height: 70,
          ),
        ]),
      );
}
