import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';

class PageCreatePostAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Function createPost;
  final bool enableBtn;
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  PageCreatePostAppBar(this.createPost, this.enableBtn);

  @override
  Widget build(BuildContext context) {
    popScreen({dynamic params}) => Navigator.pop(context, params);

    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Padding(
        padding: const EdgeInsets.only(left: 0, top: 12, bottom: 8, right: 10),
        child: Row(
          children: [
            BackButton(
              color: ptSecondaryColor(context),
              onPressed: () {
                popScreen();
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
            SizedBox(
              width: 5,
            ),
            Spacer(),
            Text(
              'Bài viết mới',
              style: ptBigTitle(),
            ),
            Spacer(),
            ExpandBtn(
              onPress: enableBtn ? createPost : null,
              text: 'ĐĂNG',
              textColor: Colors.white,
              width: 100,
            ),
          ],
        ),
      ),
      color: ptPrimaryColor(context),
    );
  }
}
