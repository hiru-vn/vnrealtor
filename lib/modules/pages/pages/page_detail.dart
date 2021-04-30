import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_create_post.dart';
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
    if(_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    if (_pagesBloc == null)  {
      _pagesBloc = Provider.of<PagesBloc>(context);
       _getPageDetail();
       _getPostPage();
    }
    super.didChangeDependencies();
  }


  Future _getPageDetail() async {
    var res;
    res = await _pagesBloc.getOnePage(_pageState.id);
    if (res.isSuccess) {
      _pagesBloc.pageDetail = res.data;
      _pagesBloc.updatePageFollowed(_authBloc.userModel.id);
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

  Future<void> _getAllPostOfPageByGuess() async => await _pagesBloc.getPostsOfPageByGuess(
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

  @override
  Widget build(BuildContext context) {
    _pagesBloc.pagePostsScrollController = ScrollController();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: _pageState.name,
        textColor: AppColors.mainColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () async {
            if (_isParamPageCreate) {
              await popUntilStep(2);
            } else {
              await popScreen();
            }
          },
        ),
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
          _buildBanner(),
          _buildHeader(),
          _buildInfoPage(),
        ],
      );

  Widget _buildBanner() => CachedNetworkImage(
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
          color: ptSecondaryColor(context),
          child: Center(
            child: ActivityIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: deviceWidth(context) / 2,
          color: ptSecondaryColor(context),
          child: Center(
            child: Icon(
              Icons.error,
              color: AppColors.mainColor,
            ),
          ),
        ),
      );

  Widget _buildHeader() => Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                if(_authBloc.userModel != null)
                  if (_authBloc.userModel.role != 'COMPANY')
                    Flexible(
                      child: _itemButtonFollow(),
                    )
              ],
            ),
            heightSpace(25),
            if(_authBloc.userModel != null)
              _authBloc.userModel.role != 'COMPANY'
                ? _buildContainerButtonsToolMessage()
                : _buildContainerButtonsToolCreatePost(_pageState.id),
            heightSpace(10),
          ],
        ),
      );

  Widget _itemHeaderInfo() => Row(
        children: [
          CachedNetworkImage(
            imageUrl: _pagesBloc.pageDetail.avartar != null
                ? _pagesBloc.pageDetail.avartar
                : "https://i.ibb.co/Zcx1Ms8/error-image-generic.png",
            imageBuilder: (context, imageProvider) => Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: ptSecondaryColor(context),
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
                color: ptSecondaryColor(context),
              ),
              child: Center(
                child: Icon(
                  Icons.error,
                  color: AppColors.mainColor,
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
                    style: ptTitle().copyWith(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 3),
              Text(
                _pagesBloc.pageDetail.category[0].name,
                style: ptSmall().copyWith(color: ptPrimaryColor(context)),
              )
            ],
          )
        ],
      );

  Widget _itemButtonFollow() => GestureDetector(
        onTap: () async {
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
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.buttonPrimaryColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: _pagesBloc.isFollowPageLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(),
                )
              : Text(
                  _pagesBloc.isFollowed ? "Bỏ theo dõi" : "Theo dõi",
                  style: ptButton(),
                ),
        ),
      );

  Widget _buildContainerButtonsToolCreatePost(String pageId) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _buildButtonCreatePost(pageId),
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
        image: AppImages.icPageMessage,
        callback: () => {},
      );

  Widget _buildButtonCreatePost(String pageId) => CustomButton(
        title: "Tạo bài viết",
        image: AppImages.icCreatePost,
        callback: () => PageCreatePostPage.navigate(pageId),
      );

  Widget _buildButtonSetting() => Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.backgroundLightColor,
        ),
        child: Image(
          width: 25,
          height: 25,
          image: AssetImage(
            AppImages.icSettingPage,
          ),
        ),
      );

  Widget _buildButtonBell() => Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: AppColors.backgroundLightColor,
        ),
        child: Image(
          width: 25,
          height: 25,
          image: AssetImage(
            AppImages.icBellPage,
          ),
        ),
      );

  Widget _buildInfoPage() => Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_pagesBloc.pageDetail.followers.length > 0)
              ItemInfoPage(
                image: AppImages.icFollower,
                title: '${_pagesBloc.pageDetail.followers.length} lượt follow',
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
