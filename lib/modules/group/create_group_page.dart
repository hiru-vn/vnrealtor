import 'package:datcao/share/import.dart';

class CreateGroupPage extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(CreateGroupPage()));
  }

  CreateGroupPage({Key key}) : super(key: key);

  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ptSecondaryColor(context),
      appBar: AppBar1(
        bgColor: ptSecondaryColor(context),
        title: 'Tạo nhóm',
        textColor: ptPrimaryColor(context),
        automaticallyImplyLeading: true,
        actions: [
          Center(
            child: FlatButton(
                color: ptPrimaryColor(context),
                onPressed: () {
                  navigatorKey.currentState.maybePop();
                },
                child: Text(
                  'Tạo',
                  style: ptTitle().copyWith(color: Colors.white),
                )),
          ),
          SizedBox(width: 17)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tên nhóm', style: ptTitle()),
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: TextField(
                  minLines: 2,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text('Quyền riêng tư', style: ptTitle()),
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: DropdownButtonFormField(
                  items: [
                    DropdownMenuItem(child: Text('Công khai'), value: 'public')
                  ],
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text('Mô tả', style: ptTitle()),
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: TextField(
                  minLines: 4,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      hintStyle: ptSmall().copyWith(color: Colors.black38),
                      hintText:
                          'Mô tả nhóm giúp mọi người biết nhiều hơn về nhóm của bạn'),
                ),
              ),
              SizedBox(height: 15),
              Text('Ảnh bìa', style: ptTitle()),
              SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4)),
                height: 136,
                width: double.infinity,
                child: Center(
                    child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: ptSecondaryColor(context),
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                    child: Icon(Icons.photo_camera_back),
                  ),
                )),
              ),
              SizedBox(height: 15),
              Text('Địa điểm', style: ptTitle()),
              SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: TextField(
                  minLines: 2,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    hintStyle: ptSmall().copyWith(color: Colors.black38),
                    hintText: 'Nhập địa điểm',
                  ),
                ),
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Row(children: [
                  Icon(MdiIcons.googleMaps),
                  SizedBox(width: 10),
                  Text('Đánh dấu trên bản đồ', style: ptBody()),
                ]),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
