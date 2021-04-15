import 'package:datcao/modules/pages/pages/InfoSocialPageCreatePage.dart';
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

  TextEditingController _nameC = TextEditingController(text: '');
  TextEditingController _describeC = TextEditingController(text: '');
  TextEditingController _categoriesController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(
      initialPage: pageInit,
    );
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Tạo Trang',
        textColor: AppColors.mainColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: PageView(
        physics: new NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: [
          InfoPageCreatePage(
            pageController: _pageController,
            nameController: _nameC,
            describeController: _describeC,
            categoriesController: _categoriesController,
          ),
          InfoSocialPageCreatePage(
            pageController: _pageController,
          ),
          ChooseImageCreatePage(
            nameController: _nameC,
            describeController: _describeC,
          )
        ],
      ),
    );
  }
}
