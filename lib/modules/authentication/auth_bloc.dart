import 'package:firebase_auth/firebase_auth.dart';
import 'package:vnrealtor/modules/model/user.dart';
import 'package:vnrealtor/modules/repo/user_repo.dart';
import 'package:vnrealtor/modules/services/base_response.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:vnrealtor/share/import.dart';
import 'package:vnrealtor/utils/formart.dart';

enum AuthStatus {
  unAuthed,
  otpSent,
  authSucces,
  authFail,
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

  final _authStatus$ = BehaviorSubject<AuthStatus>();
  Stream<AuthStatus> get authStatusStream => _authStatus$.stream;
  Sink<AuthStatus> get authStatusSink => _authStatus$.sink;
  AuthStatus get authStatusValue => _authStatus$.value;

  String smsVerifyCode;

  @mustCallSuper
  void dispose() {
    _countdownStart$.close();
    _authStatus$.close();
    super.dispose();
  }

  //Sign in with email & password
  Future<BaseResponse> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      String fbToken = await user.getIdToken();
      final res = await _userRepo.login(idToken: fbToken);
      await SPref.instance.set('token', res['token']);
      await SPref.instance.set('id', res['user']["id"]);
      userModel = UserModel.fromJson(res['user']);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
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
      return BaseResponse.success(loginRes.data);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    }
  }

  Future requestOtp(String name, String email, String password, String phone,
      {bool isResend = false}) async {
    try {
      final String phoneNumber = (phone.startsWith('+') ? "+" : "+84") +
          phone.toString().substring(1, 10);
      _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (authCredential) async {
          final res = await registerWithPhoneAuth(
              authCredential, name, email, password, phone);
          if (res.isSuccess) {
            authStatusSink.add(AuthStatus.authSucces);
          } else {
            authStatusSink.add(AuthStatus.authFail);
          }
        },
        verificationFailed: (e) {
          authStatusSink.add(AuthStatus.authFail);
          showToastNoContext(Formart.formatErrFirebaseLoginToString(e.code));
        },
        codeSent: (verificationId, [code]) {
          countdownStartSink.add(true);
          authStatusSink.add(AuthStatus.otpSent);
          smsVerifyCode = verificationId;
          // showToastNoContext('Mã OTP đã được gửi đi, vui lòng kiểm tra tin nhắn');
        },
        codeAutoRetrievalTimeout: (verificationId) {
          smsVerifyCode = verificationId;
        },
      );
    } catch (e) {
      authStatusSink.add(AuthStatus.authFail);
    }
  }

  Future submitOtp(String name, String email, String password, String phone,
      String otp) async {
    try {
      authCredential = PhoneAuthProvider.credential(
          verificationId: smsVerifyCode, smsCode: otp);
      final res = await registerWithPhoneAuth(
          authCredential, name, email, password, phone);
      if (res.isSuccess) {
        authStatusSink.add(AuthStatus.authSucces);
      } else {
        showToastNoContext('Người dùng không tồn tại.');
      }
    } catch (e) {
      showToastNoContext('Có mỗi xảy ra, vui lòng kiểm tra kết nối mạng.');
    }
  }

  Future<BaseResponse> getUserInfo() async {
    try {
      final id = await SPref.instance.get('id');
      final res = await _userRepo.getOneUser(id: id);
      userModel = UserModel.fromJson(res);
      return BaseResponse.success(res);
    } catch (e) {
      return BaseResponse.fail(e.message?.toString());
    }
  }

  Future<bool> checkToken() async {
    final String token = await SPref.instance.get('token');
    final String id = await SPref.instance.get('id');
    return token != null && id != null;
  }

  void logout() async {
    await SPref.instance.remove('token');
    await SPref.instance.remove('id');
    print('User Sign Out');
  }
}
