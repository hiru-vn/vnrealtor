import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/widget/custom_button.dart';
import 'package:datcao/modules/pages/widget/item_info_page.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/resources/styles/images.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/activity_indicator.dart';
import 'package:datcao/share/widget/base_widgets.dart';

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

  PagesCreate get _pageState => widget.page;
  bool get _isParamPageCreate => widget.isParamPageCreate;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    super.didChangeDependencies();
  }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBanner(),
              _buildHeader(),
              if(AuthBloc.instance.userModel.role != 'COMPANY')
                 _buildInfoPage(),
            ],
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
                : _buildContainerButtonsToolCreatePost(),
            heightSpace(10),
          ],
        ),
      );

  Widget _itemHeaderInfo() => Row(
        children: [
          CachedNetworkImage(
            imageUrl: _pageState.coverImage != null
                ? _pageState.coverImage
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
                _pageState.category[0].name,
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

  Widget _buildContainerButtonsToolCreatePost() => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: _buildButtonCreatePost(),
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
            _buildButtonBell()
          ],
        ),
      );

  Widget _buildButtonMessage() => CustomButton(
        title: "Nhắn tin",
        image: AppImages.icPageMessage,
      );

  Widget _buildButtonCreatePost() =>
      CustomButton(title: "Tạo bài viết", image: AppImages.icCreatePost);

  Widget _buildButtonSetting() => CustomButton(
        image: AppImages.icSettingPage,
        size: 45,
      );

  Widget _buildButtonBell() => CustomButton(
        image: AppImages.icBellPage,
        size: 45,
      );

  Widget _buildInfoPage() => Container(
    margin: const EdgeInsets.only(top : 10),
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

}
