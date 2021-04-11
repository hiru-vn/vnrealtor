import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/pages/widget/card_post.dart';
import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/resources/styles/images.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/base_widgets.dart';

class PageDetail extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(
        PageDetail(),
      ),
    );
  }

  @override
  _PageDetailState createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    if (_authBloc == null) {
      _authBloc = Provider.of<AuthBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Datcao Project',
        textColor: AppColors.mainColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
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
            image: CachedNetworkImageProvider(
                'https://firebasestorage.googleapis.com/v0/b/vnrealtor-52b40.appspot.com/o/posts%2Fuser_606af2be34e84412a7dac18c%2F1617631434321%2Fthumb@119_2021-04-0521%3A03%3A54.324888tai-hinh-nen-nha-dep-cho-may-tinh-4.jpg?alt=media&token=70ba9498-0c2e-4785-89fb-80f3189c768f'),
          ),
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
              backgroundImage: AssetImage('assets/image/default_avatar.png'),
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
                    'Name',
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

  Widget _buildCardPost() => CardPost();
}
