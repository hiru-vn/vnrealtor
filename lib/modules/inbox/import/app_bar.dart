import 'package:flutter/material.dart';

import 'font.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  final List<Widget> actions;
  final Color bgColor;
  final Widget leading;
  final String title;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final int elevation;
  final Widget icon;

  MyAppBar(
      {this.actions,
      this.bgColor,
      this.leading,
      this.title,
      this.elevation = 0,
      this.centerTitle = false,
      this.icon,
      this.automaticallyImplyLeading = false});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: bgColor ?? Colors.transparent,
      elevation: elevation.toDouble(),
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: centerTitle,
      title: Row(
        mainAxisSize: centerTitle ? MainAxisSize.min : MainAxisSize.max,
        children: [
          // if (!automaticallyImplyLeading) ...[
          //   Image.asset(
          //     'assets/image/logo.png',
          //     height: 27,
          //     width: 27,
          //   ),
          //   SizedBox(
          //     width: 7,
          //   ),
          // ],
          if (icon != null) ...[
            icon,
            SizedBox(
              width: 15,
            ),
          ],
          Text(
            title ?? '',
            style: ptBigTitle().copyWith(
                color: (bgColor != null && bgColor != Colors.white)
                    ? Colors.white
                    : Colors.black87),
          ),
        ],
      ),
      actions: actions,
    );
  }
}
