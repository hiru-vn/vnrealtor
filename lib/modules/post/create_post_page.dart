import 'package:flutter/material.dart';
import 'package:vnrealtor/share/import.dart';

class CreatePostPage extends StatefulWidget {
  static navigate() {
    navigatorKey.currentState.push(pageBuilder(CreatePostPage()));
  }

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  bool _makePublic = true;
  FocusNode _activityNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceWidth(context),
      height: deviceHeight(context),
      child: Material(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Scaffold(
              appBar: AppBar1(
                automaticallyImplyLeading: true,
                title: '',
              ),
              body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15).copyWith(top: 0),
                      child: Text(
                        'Hình ảnh/ Video',
                        style: ptBigTitle().copyWith(
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15).copyWith(top: 0),
                      child: SizedBox(
                        height: 110,
                        child: ImageRowPicker(
                          [
                            'https://i.pinimg.com/originals/38/d7/5b/38d75b985d9d08ce0959201f8198f405.jpg',
                            'https://i.pinimg.com/originals/c9/aa/f8/c9aaf8853557c381c80ee827db0dad64.jpg'
                          ],
                          onUpdateListImg: (listImg) {},
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                          maxLength: 400,
                          maxLines: null,
                          style: ptBigBody().copyWith(color: Colors.black54),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Nội dung bài viết',
                            hintStyle: ptTitle().copyWith(
                                color: Colors.black38, letterSpacing: 1),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Positioned(
              bottom: 0,
              width: deviceWidth(context),
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildForm(),
                    SizedBox(
                      height: 3.0,
                    ),
                    ExpandRectangleButton(
                      text: 'Đăng bài',
                      onTap: () {
                        navigatorKey.currentState.maybePop();
                      },
                    ),
                    SizedBox(
                      height: _activityNode.hasFocus
                          ? MediaQuery.of(context).viewInsets.bottom
                          : 0,
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

  _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          height: 3,
        ),
        InkWell(
          highlightColor: ptAccentColor(context),
          splashColor: ptPrimaryColor(context),
          onTap: () {
            // PickMyPetListpage.navigate();
          },
          child: CustomListTile(
            leading: Icon(
              Icons.map,
              color: Colors.black54,
            ),
            title: Text(
              'Gắn vị trí',
              style: ptTitle(),
            ),
            trailing: Icon(
              MdiIcons.arrowRightCircle,
              size: 20,
              color: Colors.black54,
            ),
          ),
        ),
        Divider(
          height: 3,
        ),
        CustomListTile(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now(),
              );
            },
            leading: Icon(
              Icons.date_range,
              color: Colors.black54,
            ),
            title: Text(
              'Ngày hết hạn',
              style: ptTitle(),
            ),
            trailing: Text('2/4/2020')),
        Divider(
          height: 3,
        ),
        CustomListTile(
          leading: Icon(
            Icons.language,
            color: Colors.black54,
          ),
          title: Text(
            'Chia sẻ với',
            style: ptTitle(),
          ),
          trailing: Text('Tất cả mọi người'),
          onTap: () {
            pickList(context,
                title: 'Chia sẻ với',
                onPicked: (value) {},
                options: [
                  'Tất cả mọi người',
                  'Chỉ bạn bè mới nhìn thấy',
                ],
                closeText: 'Xong');
          },
        ),
      ],
    );
  }
}
