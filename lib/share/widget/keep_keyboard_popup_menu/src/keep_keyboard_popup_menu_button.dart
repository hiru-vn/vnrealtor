import 'package:flutter/material.dart';

import './with_keep_keyboard_popup_menu.dart';

/// KeepKeyboardPopup version of [PopupMenuButton]. This is basically a remix of
/// [PopupMenuButton] and [WithKeepKeyboardPopupMenu], you can find the
/// documentation of the properties from them.
///
/// There is no tooltip property on [KeepKeyboardPopupMenuItem] because
/// currently Flutter's [Tooltip] doesn't position itself correctly when the
/// soft keyboard is opened. I think the fix should be done in the Flutter
/// framework or by another package.
class KeepKeyboardPopupMenuButton extends StatelessWidget {
  final Widget? child;
  final Widget? icon;
  final bool enabled;
  final MenuBuilder? menuBuilder;
  final MenuItemBuilder? menuItemBuilder;
  final EdgeInsetsGeometry padding;
  final double iconSize;

  const KeepKeyboardPopupMenuButton({
    Key? key,
    this.icon,
    this.enabled = true,
    this.menuBuilder,
    this.menuItemBuilder,
    this.padding = const EdgeInsets.all(8.0),
    this.iconSize = 24.0,
    this.child,
  })  : assert((menuBuilder == null) != (menuItemBuilder == null),
            'You can only pass one of [menuBuilder] and [menuItemBuilder].'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return WithKeepKeyboardPopupMenu(
      menuBuilder: menuBuilder,
      menuItemBuilder: menuItemBuilder,
      childBuilder: (context, openPopup, closePopup) {
        if (child != null) {
          return InkWell(
            onTap: enabled ? openPopup : null,
            child: child,
          );
        } else {
          return IconButton(
            icon: icon ?? _getIcon(Theme.of(context).platform)!,
            padding: padding,
            iconSize: iconSize,
            onPressed: enabled ? openPopup : null,
          );
        }
      },
    );
  }

  Icon? _getIcon(TargetPlatform platform) {
    assert(platform != null);
    switch (platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const Icon(Icons.more_vert);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return const Icon(Icons.more_horiz);
    }
    return null;
  }
}
