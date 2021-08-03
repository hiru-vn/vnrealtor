import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/profile/verify_account_page1.dart';
import 'package:datcao/modules/profile/verify_company.dart';
import 'package:datcao/share/import.dart';

class RecomendDialog extends StatefulWidget {
  RecomendDialog();

  @override
  _RecomendDialogState createState() => _RecomendDialogState();
}

class _RecomendDialogState extends State<RecomendDialog> {
  UserBloc _userBloc;
  String errMessage;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: deviceWidth(context) / 1.35),
                Text(
                  'Remove this item from cart?',
                  style: ptBigTitle().copyWith(color: Colors.green),
                ),
                SizedBox(height: 20),
                SizedBox(
                    width: deviceWidth(context) / 1.5,
                    height: errMessage != null ? 30 : 15,
                    child: errMessage != null
                        ? Center(
                            child: Text(
                              errMessage,
                              style: ptBody().copyWith(color: Colors.red),
                            ),
                          )
                        : SizedBox.shrink()),
                SizedBox(
                  width: deviceWidth(context) / 1.5,
                  child: isLoading
                      ? kLoadingSpinner
                      : Row(
                          children: [
                            Expanded(
                                child: InkWell(
                                    onTap: () {
                                      navigatorKey.currentState.maybePop(false);
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 10),
                                        child: Text('Cancel',
                                            style: ptBigBody().copyWith(
                                                color: Colors.black54)),
                                      ),
                                    ))),
                            Container(
                              height: 20,
                              width: 1,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              color: Colors.black12,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () async {},
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 10),
                                  child: Text('Remove',
                                      style: ptBigBody().copyWith(
                                          color: ptPrimaryColor(context))),
                                ),
                              ),
                            )),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FunkyOverlay extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FunkyOverlayState();
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  UserBloc _userBloc;
  String errMessage;
  bool isLoading = false;
  bool notShowAgain = false;

  @override
  void didChangeDependencies() {
    if (_userBloc == null) {
      _userBloc = Provider.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Material(
              color: Colors.transparent,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: deviceWidth(context) / 1.35),
                      SizedBox(
                        width: deviceWidth(context) / 1.5,
                        child: Text(
                          'Hãy xác minh nhà môi giới để được đăng bài nhiều hơn.',
                          style: ptTitle().copyWith(color: Colors.green),
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: deviceWidth(context) / 1.5,
                        child: Center(
                          child: SizedBox(
                            width: 90,
                            child: Image.asset('assets/image/verify.png'),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: deviceWidth(context) / 1.5,
                          height: errMessage != null ? 30 : 15,
                          child: errMessage != null
                              ? Center(
                                  child: Text(
                                    errMessage,
                                    style: ptBody().copyWith(color: Colors.red),
                                  ),
                                )
                              : SizedBox.shrink()),
                      SizedBox(
                        width: deviceWidth(context) / 1.5,
                        child: Text(
                          'Chỉ bằng vài bước đơn giản, chúng tôi sẽ xác nhận bạn với vai trò là nhà môi giới sau khi nhận được yêu cầu xác thực thông tin.',
                          style: ptBody(),
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth(context) / 1.5 + 28,
                        child: Row(
                          children: [
                            Checkbox(
                              value: notShowAgain,
                              onChanged: (val) {
                                setState(() {
                                  notShowAgain = !notShowAgain;
                                });
                              },
                              checkColor: Colors.black,
                              activeColor: Colors.grey[300],
                              visualDensity:
                                  VisualDensity(horizontal: 0, vertical: 0),
                            ),
                            Text(
                              'Không nhắc nữa',
                              style: ptSmall(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth(context) / 1.5,
                        child: isLoading
                            ? kLoadingSpinner
                            : Row(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            if (notShowAgain == true)
                                              SPref.instance.setBool(
                                                  'notShowRecomendAgain', true);
                                            navigatorKey.currentState
                                                .maybePop(false);
                                          },
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 10),
                                              child: Text('Đóng',
                                                  style: ptBigBody().copyWith(
                                                      color: Colors.black54)),
                                            ),
                                          ))),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    color: Colors.black12,
                                  ),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () async {
                                      if (notShowAgain == true)
                                        SPref.instance.setBool(
                                            'notShowRecomendAgain', true);
                                      if (AuthBloc.instance.userModel.role ==
                                          'COMPANY') {
                                        VerifyCompany.navigate().then((value) =>
                                            navigatorKey.currentState
                                                .maybePop());
                                        return;
                                      }
                                      VertifyAccountPage1.navigate().then(
                                          (value) => navigatorKey.currentState
                                              .maybePop());
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 10),
                                        child: Text('Xác minh',
                                            style: ptBigBody().copyWith(
                                                color:
                                                    ptPrimaryColor(context))),
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
