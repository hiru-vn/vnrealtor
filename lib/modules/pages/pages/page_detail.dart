import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/pages/models/pages_create_model.dart';
import 'package:datcao/modules/pages/widget/card_post.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/resources/styles/images.dart';
import 'package:datcao/share/import.dart';
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBanner(),
              _buildHeader(),
              heightSpace(25),
              if (AuthBloc.instance.userModel.role != 'COMPANY')
                _buildButtonMessage(),
              if (AuthBloc.instance.userModel.role == 'COMPANY')
                _buildCardPost()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() => Container(
        height: deviceWidth(context) / 2,
        decoration: BoxDecoration(
          color: AppColors.backgroundLightColor,
          image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(  _pageState.coverImage != null
                  ? _pageState.coverImage
                  : "https://i.ibb.co/Zcx1Ms8/error-image-generic.png")),
        ),
      );

  Widget _buildHeader() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
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
      );

  Widget _itemHeaderInfo() => Row(
        children: [
          Center(
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: CachedNetworkImage(
                imageUrl: _pageState.avartar != null
                    ? _pageState.avartar
                    : "https://i.ibb.co/Zcx1Ms8/error-image-generic.png",
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
                'Cập nhật thông tin',
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

  Widget _buildButtonMessage() => Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: FlatButton(
                // elevation: elevation?.toDouble() ?? 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                color: AppColors.backgroundLightColor,
                onPressed: () => {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(AppImages.icPageMessage),
                    widthSpace(10),
                    Text(
                      "Nhắn tin",
                      style: ptButton().copyWith(color: AppColors.mainColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          heightSpace(20),
        ],
      );

  Widget _buildCardPost() => CardPost(page: _pageState,);
}
