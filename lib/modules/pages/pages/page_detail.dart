import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/pages/page_create_post.dart';
import 'package:datcao/modules/pages/widget/custom_button.dart';
import 'package:datcao/modules/pages/widget/item_info_page.dart';
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
    if (_pagesBloc == null) {
      _authBloc = Provider.of(context);
      _pagesBloc = Provider.of<PagesBloc>(context);
      _getAllPostOfPage();
    }
    super.didChangeDependencies();
  }

  Future<void> _getAllPostOfPage() async => await _pagesBloc.getPostsOfPage(
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
                   _buildBanner(),
                   _buildHeader(),
                  if (AuthBloc.instance.userModel.role != 'COMPANY')
                    _buildInfoPage(),
                  _buildListPostOfPage()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() => CachedNetworkImage(
        imageUrl: _pageState.coverImage != null
            ? _pageState.coverImage
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
                if (AuthBloc.instance.userModel.role != 'COMPANY')
                  Flexible(
                    child: _itemButtonFollow(),
                  )
              ],
            ),
            heightSpace(25),
            AuthBloc.instance.userModel.role != 'COMPANY'
                ? _buildContainerButtonsToolMessage()
                : _buildContainerButtonsToolCreatePost(_pageState.id),
            heightSpace(10),
          ],
        ),
      );

  Widget _itemHeaderInfo() => Row(
        children: [
          CachedNetworkImage(
            imageUrl: _pageState.avartar != null
                ? _pageState.avartar
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
                    _pageState.name,
                    style: ptTitle().copyWith(fontWeight: FontWeight.w900),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              SizedBox(height: 3),
              Text(
                _pageState.categoryIds[0],
                style: ptSmall().copyWith(color: ptPrimaryColor(context)),
              )
            ],
          )
        ],
      );

  Widget _itemButtonFollow() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.buttonPrimaryColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          "Theo dõi",
          style: ptButton(),
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
            ItemInfoPage(
              image: AppImages.icFollower,
              title: '60 lượt follow',
            ),
            heightSpace(10),
            ItemInfoPage(
              image: AppImages.icLocation,
              title: 'Thành phố Hồ Chí Minh',
            ),
            heightSpace(10),
            ItemInfoPage(
              image: AppImages.icPhone,
              title: '+84989078790',
            ),
            heightSpace(10),
            ItemInfoPage(
              image: AppImages.icSocial,
              title: 'datcaogroup.com',
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
