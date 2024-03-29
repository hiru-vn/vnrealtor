import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/pages/blocs/pages_bloc.dart';
import 'package:datcao/modules/pages/pages/page_detail.dart';
import 'package:datcao/modules/pages/widget/own_page_loading.dart';
import 'package:datcao/modules/pages/widget/page_skeleton.dart';
import 'package:datcao/modules/pages/widget/suggestListPages.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/resources/styles/images.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';

import 'create_page_page.dart';

class PagesPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(
        PagesPage(),
      ),
    );
  }

  @override
  _PagesPageState createState() => _PagesPageState();
}

class _PagesPageState extends State<PagesPage> {
  PagesBloc _pagesBloc;
  AuthBloc _authBloc;

  bool isDataPageLoading = false;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of(context);
    }
    if (_pagesBloc == null) {
      _pagesBloc = Provider.of<PagesBloc>(context)
        ..feedScrollController = ScrollController();
      if (_authBloc.userModel.role == 'COMPANY') {
        _fetchDataCompany();
      } else {
        _fetchData();
      }
    }
    super.didChangeDependencies();
  }

  Future<void> _fetchDataCompany() async {
    setState(() => isDataPageLoading = true);
    await _getSuggestFollow();
    await _getAllPageCreated();
    await _getAllPageFollow();
    await _pagesBloc.getAllHashTagTP();
    setState(() => isDataPageLoading = false);
  }

  Future<void> _fetchData() async {
    setState(() => isDataPageLoading = true);
    await _getSuggestFollow();
    await _getAllPageFollow();
    setState(() => isDataPageLoading = false);
  }

  Future<void> _getAllPageCreated() async => await _pagesBloc.getMyPage();

  Future<void> _getAllPageFollow() async => await _pagesBloc.getPagesFollow(
      filter: GraphqlFilter(limit: 15, page: 1),
      userId: _authBloc.userModel.id);

  Future<void> _getSuggestFollow() async => await _pagesBloc.suggestFollow();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar1(
          bgColor: ptSecondaryColor(context),
          title: 'Trang',
          textColor: AppColors.mainColor,
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: RefreshIndicator(
          color: ptPrimaryColor(context),
          onRefresh: () async {audioCache.play('tab3.mp3');
            if (AuthBloc.instance.userModel.role == 'COMPANY') {
              _fetchDataCompany();
            } else {
              _fetchData();
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _pagesBloc.feedScrollController,
            child: isDataPageLoading
                ? PageSkeleton()
                : Container(
                    height: deviceHeight(context),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor.withOpacity(0.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _pagesBloc.suggestFollowPage.isNotEmpty
                            ? SuggestListPages(
                                suggest: _pagesBloc.suggestFollowPage)
                            : const SizedBox(),
                        if (AuthBloc.instance.userModel.role == 'COMPANY')
                          _buildHeader(),
                        if (AuthBloc.instance.userModel.role == 'COMPANY')
                          _buildSectionOwnPage(),
                        _buildPageBodySection(
                            'Trang đã theo dõi', AppImages.icPageFollow),
                        _buildSectionPageFollow(),
                        // heightSpace(10),
                        // _buildPageBodySection(
                        //     'Lời mời thích trang ', AppImages.icPageLike),
                        // _itemBodySectionPageLike(AppImages.imageDemo, 'Dự án MeiLand '),
                        heightSpace(30),
                      ],
                    ),
                  ),
          ),
        ));
  }

  Widget _buildSectionOwnPage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPageBodySection('Trang của bạn', AppImages.icOwnPage),
          _buildListPageCreate()
        ],
      );

  Widget _buildOwnPageLoading() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 40,
              blurRadius: 40.0,
              offset: Offset(0, 10),
              color: Color.fromRGBO(0, 0, 0, 0.03),
            )
          ],
        ),
        child: OwnPageLoading(),
      );

  Widget _buildListPageCreate() {
    List<Widget> _listWidget = [];
    _pagesBloc.pageCreated.forEach(
      (page) => _listWidget.add(
        _itemBodySectionOwnPage(
          page.avartar,
          page.name,
          2,
          _pagesBloc.pageCreated.last == page ? true : false,
          () => PageDetail.navigate(page),
        ),
      ),
    );
    return _listWidget.length > 0
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 40,
                  blurRadius: 40.0,
                  offset: Offset(0, 10),
                  color: Color.fromRGBO(0, 0, 0, 0.03),
                )
              ],
            ),
            child: Column(
              children: _listWidget,
            ),
          )
        : const SizedBox();
  }

  Widget _buildListPageFollow() {
    List<Widget> _listWidget = [];
    _pagesBloc.listPageFollow.forEach(
      (page) => _listWidget.add(
        _itemBodySectionPageFollow(
          page.avartar,
          page.name,
          2,
          _pagesBloc.listPageFollow.last == page ? true : false,
          () => PageDetail.navigate(page),
        ),
      ),
    );
    return _listWidget.length > 0
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 40,
                  blurRadius: 40.0,
                  offset: Offset(0, 10),
                  color: Color.fromRGBO(0, 0, 0, 0.03),
                )
              ],
            ),
            child: Column(
              children: _listWidget.isNotEmpty ? _listWidget : Container(),
            ),
          )
        : const SizedBox();
  }

  Widget _buildSectionPageFollow() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildListPageFollow()],
      );

  Widget _buildHeader() => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 18),
        child: _itemIconButtonTitle(
          AppImages.icCreatePage,
          'Tạo trang mới',
          41,
          action: () => CreatePagePage.navigate(),
        ),
      );

  Widget _itemIconButtonTitle(String image, String title, double iconSize,
          {VoidCallback action}) =>
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              action();
              audioCache.play('tab3.mp3');
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Center(
                  child: SizedBox(
                    width: iconSize,
                    height: iconSize,
                    child: Image.asset(
                      image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
          ),
          widthSpace(15),
          Container(
            child: Text(
              title,
              style: ptBigTitle().copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      );

  Widget _buildPageBodySection(String title, String icon) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: _itemIconButtonTitle(icon, title, 32),
            ),
          ],
        ),
      );

  Widget _itemBodySectionOwnPage(String image, String title, int number,
          bool isLast, VoidCallback callback) =>
      GestureDetector(
        onTap: () {
          callback();
          audioCache.play('tab3.mp3');
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 19, top: 11),
          decoration: BoxDecoration(
            border: !isLast
                ? Border(
                    bottom: BorderSide(
                      color: AppColors.borderGrayColor.withOpacity(0.3),
                      width: 0.5,
                    ),
                  )
                : Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Center(
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: CachedNetworkImage(
                        imageUrl: image.isNotEmpty
                            ? image
                            : 'https://i.ibb.co/Zcx1Ms8/error-image-generic.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              widthSpace(13),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      title,
                      style: ptBigBody().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  heightSpace(7),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: new BoxDecoration(
                            color: AppColors.notifyColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        widthSpace(8),
                        Text(
                          number.toString() + ' mục mới',
                          style: ptSmall(),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget _itemBodySectionPageFollow(String image, String title, int number,
          bool isLast, VoidCallback callback) =>
      GestureDetector(
        onTap: () {
          callback();
          audioCache.play('tab3.mp3');
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 19, top: 11),
          decoration: BoxDecoration(
            border: !isLast
                ? Border(
                    bottom: BorderSide(
                      color: AppColors.borderGrayColor.withOpacity(0.3),
                      width: 0.5,
                    ),
                  )
                : Border(
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Center(
                    child: SizedBox(
                      width: 45,
                      height: 45,
                      child: CachedNetworkImage(
                        imageUrl: image.isNotEmpty
                            ? image
                            : 'https://i.ibb.co/Zcx1Ms8/error-image-generic.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              widthSpace(13),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      title,
                      style: ptBigBody().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  heightSpace(7),
                  _itemButton('Đã theo dõi', isApprove: true, icon: Icons.check)
                ],
              )
            ],
          ),
        ),
      );

  Widget _itemBodySectionPageLike(
    String image,
    String title,
  ) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 40,
              blurRadius: 40.0,
              offset: Offset(0, 10),
              color: Color.fromRGBO(0, 0, 0, 0.03),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Center(
                  child: SizedBox(
                    width: 45,
                    height: 45,
                    child: Image.asset(
                      image,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            widthSpace(13),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    title,
                    style: ptBigBody().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                heightSpace(7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _itemButton('Đã theo dõi',
                        isApprove: true, icon: Icons.check),
                    widthSpace(10),
                    _itemButton('Từ chối', isApprove: false),
                  ],
                )
              ],
            )
          ],
        ),
      );

  Widget _itemButton(String text, {bool isApprove = false, IconData icon}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isApprove ? AppColors.buttonApprove : AppColors.buttonCancel,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isApprove
                ? Container(
                    child: Icon(
                    icon,
                    size: 14,
                    color: AppColors.mainColor,
                  ))
                : const SizedBox(),
            widthSpace(8),
            Text(
              text,
              style: ptSmall().copyWith(color: AppColors.mainColor),
            )
          ],
        ),
      );
}
