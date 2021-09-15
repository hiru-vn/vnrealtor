import 'dart:developer';
import 'dart:io';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/profile/profile_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/modules/profile/profile_other_page.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/utils/role_user.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(QRCodeScreen()));
  }

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentTab = 0;
  UserBloc _userBloc;
  UserModel _user;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    _user = AuthBloc.instance.userModel;
    super.initState();
  }

  _onScanned(Barcode result) async {
    print(result.code);
    showWaitingDialog(context);
    var res = await _userBloc.getOneUserForClient(result.code);
    if (res.isSuccess) {
      print(res.data);
      if (_user.friendIds.contains(result.code)) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Đã được kết nối"),
                  content: Text("Bạn và ${res.data.name} đã được kết nối!"),
                  actions: [
                    TextButton(
                      child: Text(
                        "Xong",
                        style:
                            ptBody().copyWith(color: ptSecondaryColor(context)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text(
                        "Đến trang cá nhân",
                        style:
                            ptBody().copyWith(color: ptSecondaryColor(context)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ProfileOtherPage.navigate(res.data);
                      },
                    )
                  ],
                ));
      } else {
        var _makeFriend = await _userBloc.makeFriend(result.code);
        if (_makeFriend.isSuccess) {
          setState(() {
            _user = _makeFriend.data;
          });
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Kết nối thành công"),
                    content: Text("Bạn và ${res.data.name} đã được kết nối!"),
                    actions: [
                      TextButton(
                        child: Text(
                          "Xong",
                          style: ptBody()
                              .copyWith(color: ptSecondaryColor(context)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text(
                          "Đến trang cá nhân",
                          style: ptBody()
                              .copyWith(color: ptSecondaryColor(context)),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          ProfileOtherPage.navigate(res.data);
                        },
                      )
                    ],
                  ));
          closeLoading();
          return true;
        }
      }
    } else {
      showToast("Mã code không hợp lệ", context);
      closeLoading();
      return false;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_userBloc == null) {
      _userBloc = Provider.of<UserBloc>(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ptPrimaryColor(context),
      child: SafeArea(
        child: Scaffold(
          appBar: SecondAppBar(
            title: "Mã QR DATCAO",
          ),
          body: Column(
            children: [
              Container(
                color: ptPrimaryColor(context),
                child: TabBar(
                  tabs: [
                    Align(
                      alignment: Alignment.center,
                      child: Text("Quét"),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text("Mã QR của tôi"))
                  ],
                  indicatorSize: TabBarIndicatorSize.tab,
                  onTap: (value) {
                    setState(() {
                      currentTab = value;
                    });
                  },
                  indicatorWeight: 3,
                  indicatorColor: ptSecondColor(),
                  labelPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                  controller: _tabController,
                  labelColor: ptSecondColor(),
                  unselectedLabelColor: Theme.of(context).accentColor,
                  unselectedLabelStyle:
                      TextStyle(fontSize: 14, color: Colors.black12),
                  labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold),
                ),
              ),
              AnimatedBuilder(
                  animation: _tabController.animation,
                  builder: (ctx, child) {
                    if (_tabController.index == 0) {
                      return Expanded(
                          child: QRScanner(
                        onScanned: (result) => _onScanned(result),
                      ));
                    } else
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, left: 30, right: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: ptPrimaryColor(context),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.all(40.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  _user?.name,
                                                  style: ptTitle(),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Text(
                                                  convertRoleUser(_user.role),
                                                  style: ptBody(),
                                                ),
                                                QrImage(
                                                  data: _user.id,
                                                  backgroundColor: Colors.white,
                                                  version: QrVersions.auto,
                                                  size: 250.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 60),
                                          child: GestureDetector(
                                            onTap: null,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/image/share_icon.png",
                                                  width: 30,
                                                ),
                                                SizedBox(width: 10),
                                                Text("Chia sẻ mã QR của tôi"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 60),
                                          child: GestureDetector(
                                            onTap: null,
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  "assets/image/download_icon.png",
                                                  width: 30,
                                                ),
                                                SizedBox(width: 10),
                                                Text("Lưu vào thư viện"),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    audioCache.play('tab3.mp3');
                                    ProfileOtherPage.navigate(_user);
                                  },
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      backgroundImage: _user?.avatar != null
                                          ? CachedNetworkImageProvider(
                                              _user?.avatar)
                                          : AssetImage(
                                              'assets/image/default_avatar.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class QRScanner extends StatefulWidget {
  final Function(Barcode) onScanned;

  const QRScanner({Key key, this.onScanned}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildQrView(context),
        Positioned(
            top: 0,
            right: 0,
            child: IconButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
                icon: FutureBuilder(
                  future: controller?.getFlashStatus(),
                  builder: (context, snapshot) {
                    return Icon(
                        snapshot.hasData && snapshot.data
                            ? Icons.flash_off_rounded
                            : Icons.flash_on_rounded,
                        color: Colors.white);
                  },
                ))),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 450.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      widget.onScanned(scanData).then((value) {
        setState(() {
          controller.resumeCamera();
        });
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
