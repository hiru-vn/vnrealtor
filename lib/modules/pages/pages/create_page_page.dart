import 'package:datcao/resources/styles/colors.dart';
import 'package:datcao/share/import.dart';
import 'choose_image_create_page.dart';
import 'info_page_create_page.dart';

class CreatePagePage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(CreatePagePage()));
  }

  @override
  _CreatePagePageState createState() => _CreatePagePageState();
}

class _CreatePagePageState extends State<CreatePagePage> {
  int pageInit = 0;

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: pageInit);
    return Scaffold(
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Tạo Trang',
        textColor: AppColors.mainColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: PageView(
        physics:new NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          InfoPageCreatePage(pageController: _pageController,),
          ChooseImageCreatePage()
        ],
      ),
    );
  }
}
