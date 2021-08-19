import 'package:datcao/main.dart';
import 'package:datcao/modules/pages/models/registers/form_register_page.dart';
import 'package:datcao/modules/pages/models/registers/input_code_page.dart';
import 'package:datcao/share/import.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sentry/sentry.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);
  static Future navigate() {
    return navigatorKey.currentState.push(
        pageBuilder(RegisterPage(), transitionBuilder: transitionRightBuilder));
  }

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int currentTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          "ĐĂNG KÝ",
          style: roboto_18_700().copyWith(color: ptMainColor()),
        )),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: ptSecondaryColor(context),
      body: Container(
        height: deviceHeight(context),
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom != 0
                  ? -MediaQuery.of(context).viewInsets.bottom
                  : 0,
              right: 0,
              child: Container(width: deviceWidth(context), child: splash2),
            ),
            // SingleChildScrollView(
            //   child: Column(
            //     children: [],
            //   ),
            // ),
            SingleChildScrollView(
              child: Container(
                width: deviceWidth(context),
                height: deviceHeight(context),
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Text(
                          currentTab == 0
                              ? "Vui lòng nhập mã quốc gia và số điện thoại đăng ký"
                              : "Vui lòng nhập địa chỉ email và chúng tôi sẽ gửi sẽ gửi cho bạn 1 mã code",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: Container(
                        child: TabBar(
                          tabs: [
                            Align(
                              alignment: Alignment.center,
                              child: Text("Số điện thoại"),
                            ),
                            Align(
                                alignment: Alignment.center,
                                child: Text("Email"))
                          ],
                          indicatorSize: TabBarIndicatorSize.tab,
                          onTap: (value) {
                            setState(() {
                              currentTab = value;
                            });
                          },
                          indicatorWeight: 3,
                          indicatorColor: ptSecondColor(),
                          labelPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          indicatorPadding:
                              EdgeInsets.symmetric(horizontal: 10),
                          controller: _tabController,
                          labelColor: ptSecondColor(),
                          unselectedLabelColor: Colors.black54,
                          unselectedLabelStyle:
                              TextStyle(fontSize: 14, color: Colors.black12),
                          labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(controller: _tabController, children: [
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ResisterByPhoneForm(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: ResisterByEmailForm(),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResisterByPhoneForm extends StatefulWidget {
  @override
  _ResisterByPhoneFormState createState() => _ResisterByPhoneFormState();
}

class _ResisterByPhoneFormState extends State<ResisterByPhoneForm> {
  PhoneNumber _initPhoneNumber = PhoneNumber(isoCode: 'VN');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: HexColor.fromHex("#F5F5F5"),
                border: Border.all(color: HexColor.fromHex("#E5E5E5")),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                print(number.phoneNumber);
              },
              onInputValidated: (bool value) {
                print(value);
              },
              initialValue: _initPhoneNumber,
              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.DIALOG,
              ),
              searchBoxDecoration: InputDecoration(
                hintText: "Tìm kiếm",
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: TextStyle(
                color: HexColor.fromHex("#BBBBBB"),
              ),
              // textFieldController: controller,
              formatInput: false,
              hintText: "Số điện thoại",
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: InputBorder.none,
              onSaved: (PhoneNumber number) {
                print('On Saved: $number');
              },
            ),
          ),
          SizedBox(
            height: 150,
          ),
          ExpandBtn(
              width: 200,
              text: "TIẾP THEO",
              onPress: () =>
                  InputPinCodePage.navigate(phoneNumber: "+84375475075"))
        ],
      ),
    );
  }
}

class ResisterByEmailForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomInputField(
            icon: Image.asset(
              "assets/image/email_icon.png",
              width: 30,
            ),
            hintText: "Email",
          ),
          SizedBox(
            height: 150,
          ),
          ExpandBtn(width: 200, text: "TIẾP THEO", onPress: null)
        ],
      ),
    );
  }
}
