import 'package:vnrealtor/share/import.dart';
import 'package:dotted_border/dotted_border.dart';

class VertifyAccountPage2 extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(
      pageBuilder(VertifyAccountPage2(),
          transitionBuilder: transitionRightBuilder),
    );
  }

  @override
  _VertifyAccountPage2State createState() => _VertifyAccountPage2State();
}

class _VertifyAccountPage2State extends State<VertifyAccountPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2('Xác minh nhà môi giới'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SpacingBox(h: 3),
            SizedBox(
              width: deviceWidth(context) / 1.3,
              child: Text(
                'Cập nhật thêm 1 số thông tin là bạn đã hoàn tất!',
                textAlign: TextAlign.center,
                style: ptBigTitle(),
              ),
            ),
            SpacingBox(h: 3),
            Container(
              width: deviceWidth(context),
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  _buildTextField('Địa chỉ hiện tại'),
                  SizedBox(height: 15),
                  _buildTextField('Số điện thoại'),
                  SizedBox(height: 15),
                  _buildTextField('Website (nếu có)'),
                  SizedBox(height: 15),
                  _buildTextField('Mạng xã hội (FB) (nếu có)'),
                  SpacingBox(h: 5),
                  RoundedBtn(
                    height: 45,
                    text: 'Hoàn tất',
                    onPressed: () async {
                      await navigatorKey.currentState.maybePop();
                      await navigatorKey.currentState.maybePop();
                    },
                    width: 150,
                    color: ptPrimaryColor(context),
                    padding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTextField(String hint) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                ),
              ),
            )),
      );
}
