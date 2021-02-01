import 'package:firebase_auth/firebase_auth.dart';
import 'package:vnrealtor/modules/authentication/login.dart';
import 'package:vnrealtor/modules/bloc/user_bloc.dart';
import 'package:vnrealtor/modules/home_page.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/repo/user_repo.dart';
import 'package:vnrealtor/modules/services/base_response.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:vnrealtor/modules/services/firebase_service.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/utils/device_info.dart';
import 'package:vnrealtor/utils/formart.dart';

enum AuthStatus {
  unAuthed,
  otpSent,
  authSucces,
  authFail,
  requestOtp,
  successOtp,
}

class AuthResponse {
  AuthStatus status;
  bool isSuccess;
  String errMessage;

  AuthResponse({this.errMessage, this.isSuccess = false, this.status});

  factory AuthResponse.success() {
    return AuthResponse(isSuccess: true, status: AuthStatus.authSucces);
  }
  factory AuthResponse.fail(String err) {
    return AuthResponse(
        errMessage: err, isSuccess: false, status: AuthStatus.authFail);
  }
  factory AuthResponse.otpSent() {
    return AuthResponse(isSuccess: true, status: AuthStatus.otpSent);
  }
  factory AuthResponse.unAuthed() {
    return AuthResponse(isSuccess: false, status: AuthStatus.unAuthed);
  }
  factory AuthResponse.requestOtp() {
    return AuthResponse(isSuccess: true, status: AuthStatus.requestOtp);
  }
  factory AuthResponse.successOtp() {
    return AuthResponse(isSuccess: true, status: AuthStatus.successOtp);
  }
}

class AuthBloc extends ChangeNotifier {
  AuthBloc._privateConstructor();
  static final AuthBloc instance = AuthBloc._privateConstructor();

  UserRepo _userRepo = UserRepo();
  UserModel userModel;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCredential authCredential;

  final _countdownStart$ = BehaviorSubject<bool>();
  Stream<bool> get countdownStartStream => _countdownStart$.stream;
  Sink<bool> get countdownStartSink => _countdownStart$.sink;
  bool get countdownStartValue => _countdownStart$.value;

  final _authStatus$ = BehaviorSubject<AuthResponse>();
  Stream<AuthResponse> get authStatusStream => _authStatus$.stream;
  Sink<AuthResponse> get authStatusSink => _authStatus$.sink;
  AuthResponse get authStatusValue => _authStatus$.value;

  String smsVerifyCode;

  @mustCallSuper
  void dispose() {
    _countdownStart$.close();
    _authStatus$.close();
    super.dispose();
  }

  //Sign in with email & password
  Future<BaseResponse> signIn(String name, String password) async {
    try {
      if (Validator.isPhone(name)) {
        name = (name.startsWith('+') ? "+" : "+84") +
            name.toString().substring(1, 10);
      }
      final deviceId = await DeviceInfo.instance.getDeviceId();
      final deviceToken = await FirebaseService.instance.getDeviceToken();
      final res = await _userRepo.login(
          userName: name,
          password: password,
          deviceId: deviceId,
          deviceToken: deviceToken);
      await SPref.instance.set('token', res['token']);
      await SPref.instance.set('id', res['user']["id"]);
      userModel = UserModel.fromJson(res['user']);
      UserBloc.instance.init();
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    }
  }

  //Register with email & password
  Future<BaseResponse> registerWithPhoneAuth(PhoneAuthCredential phoneAuth,
      String name, String email, String password, String phone) async {
    try {
      final auth = await FirebaseAuth.instance.signInWithCredential(phoneAuth);
      if (auth == null) return BaseResponse.fail('Không tìm thấy tài khoản');
      final fbToken = await auth.user.getIdToken();
      final loginRes = await _userRepo.registerWithPhone(
          name: name,
          email: email,
          password: password,
          phone: phone,
          idToken: fbToken);
      await SPref.instance.set('token', loginRes['token']);
      await SPref.instance.set('id', loginRes['user']["id"]);
      userModel = UserModel.fromJson(loginRes['user']);
      return BaseResponse.success(loginRes);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    }
  }

  Future requestOtp(String name, String email, String password, String phone,
      {bool isResend = false}) async {
    try {
      final String phoneNumber = (phone.startsWith('+') ? "+" : "+84") +
          phone.toString().substring(1, 10);
      authStatusSink.add(AuthResponse.requestOtp());
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (authCredential) async {
          final res = await registerWithPhoneAuth(
              authCredential, name, email, password, phone);
          if (res.isSuccess) {
            authStatusSink.add(AuthResponse.success());
          } else {
            authStatusSink.add(AuthResponse.fail(res.errMessage));
          }
        },
        verificationFailed: (e) {
          authStatusSink.add(AuthResponse.fail(
              Formart.formatErrFirebaseLoginToString(e.code)));
        },
        codeSent: (verificationId, [code]) {
          countdownStartSink.add(true);
          authStatusSink.add(AuthResponse.otpSent());
          smsVerifyCode = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          smsVerifyCode = verificationId;
        },
      );
    } catch (e) {
      authStatusSink.add(AuthResponse.fail(e.toString()));
    }
  }

  Future submitOtp(String name, String email, String password, String phone,
      String otp) async {
    try {
      authCredential = PhoneAuthProvider.credential(
          verificationId: smsVerifyCode, smsCode: otp);
      authStatusSink.add(AuthResponse.successOtp());
      final res = await registerWithPhoneAuth(
          authCredential, name, email, password, phone);
      if (res.isSuccess) {
        authStatusSink.add(AuthResponse.success());
      } else {
        authStatusSink.add(AuthResponse.fail(res.errMessage));
      }
    } catch (e) {
      authStatusSink.add(AuthResponse.fail(e?.toString()));
    }
  }

  bool checkOtp(String otp) {
    try {
      authCredential = PhoneAuthProvider.credential(
          verificationId: smsVerifyCode, smsCode: otp);
      if (authCredential == null) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<BaseResponse> getUserInfo() async {
    try {
      final id = await SPref.instance.get('id');
      final res = await _userRepo.getOneUser(id: id);
      userModel = UserModel.fromJson(res);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e?.toString());
    }
  }

  Future<bool> checkToken() async {
    final String token = await SPref.instance.get('token');
    final String id = await SPref.instance.get('id');
    print(id);
    print(token);
    return token != null && id != null;
  }

  void logout() async {
    await SPref.instance.remove('token');
    await SPref.instance.remove('id');
    print('User Sign Out');
    navigatorKey.currentState
        .pushAndRemoveUntil(pageBuilder(LoginPage()), (route) => false);
  }
}
