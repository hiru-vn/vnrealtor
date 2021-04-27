import 'package:datcao/modules/authentication/auth_bloc.dart';
import 'package:datcao/modules/bloc/user_bloc.dart';
import 'package:datcao/modules/model/user.dart';
import 'package:datcao/share/import.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import './keep_keyboard_popup_menu/keep_keyboard_popup_menu.dart';

class TagUserField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final InputDecoration decoration;
  final double keyboardPadding;
  final Function onTap;
  final Function(List<String>) onUpdateTags;

  TagUserField(
      {this.controller,
      this.onTap,
      this.focusNode,
      this.onSubmitted,
      this.decoration,
      this.keyboardPadding = 0,
      this.onUpdateTags});

  @override
  _TagUserFieldState createState() => _TagUserFieldState();
}

class _TagUserFieldState extends State<TagUserField> {
  List<String> words = [];
  List<String> comments = [];
  String str = '';
  String err;
  String lastText = '';
  List<UserModel> tagUsers = [];

  static List<UserModel> tagablePeople;

  @override
  void initState() {
    super.initState();
    _getTagable();
  }

  Future _getTagable() async {
    final res = await UserBloc.instance.getListUserIn([
      ...AuthBloc.instance.userModel.friendIds,
      ...AuthBloc.instance.userModel.followingIds
    ].toSet().toList());
    if (res.isSuccess) {
      setState(() {
        tagablePeople = res.data;
        err = null;
      });
    } else {
      setState(() {
        err = 'Không thể lấy danh sách';
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      WithKeepKeyboardPopupMenu(
        menuBuilder: tagablePeople != null
            ? null
            : (context, closePopup) => Padding(
                  padding: const EdgeInsets.all(12),
                  child: kLoadingSpinner,
                ),
        menuItemBuilder: tagablePeople == null
            ? null
            : (context, closePopup) => tagablePeople
                .where((s) => ('@' + s.name).toLowerCase().contains(str))
                .map((e) => KeepKeyboardPopupMenuItem(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.controller
                              .text = widget.controller.text.substring(0,
                                  widget.controller.text.length - str.length) +
                              '@' +
                              e.name;
                          widget.controller.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: widget.controller.text.length));
                        });

                        closePopup();
                        tagUsers.add(e);
                        widget.onUpdateTags(tagUsers.map((e) => e.id).toList());
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 17,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(
                                  'assets/image/default_avatar.png')),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.name,
                                style: ptBody().copyWith(color: Colors.black),
                              ),
                              Text(
                                'Bạn bè',
                                style: ptTiny().copyWith(color: Colors.black54),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () {}))
                .toList(),
        childBuilder: (context, openPopup, closePopup) => TextField(
            onTap: widget.onTap,
            focusNode: widget.focusNode,
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            maxLines: null,
            decoration: widget.decoration,
            style: TextStyle(
              color: Colors.black,
            ),
            onChanged: (val) {
              setState(() {
                words = val.split(' ');
                str =
                    words.length > 0 && words[words.length - 1].startsWith('@')
                        ? words[words.length - 1].toLowerCase()
                        : '';
              });
              if (str.replaceAll('@', '').trim() != '' &&
                  tagablePeople != null &&
                  tagablePeople
                          .map((e) => e.name)
                          .where((s) => ('@' + s).toLowerCase().contains(str))
                          .length >
                      0) {
                closePopup().then(
                    (value) => Future.delayed(Duration(milliseconds: 100), () {
                          if (val.length > lastText.length) openPopup();
                          lastText = val;
                        }));
              } else {
                closePopup();
                lastText = val;
              }
            }),
        calculatePopupPosition:
            (Size menuSize, Rect overlayRect, Rect buttonRect) {
          return Offset(
              buttonRect.left,
              deviceHeight(context) -
                  widget.keyboardPadding -
                  menuSize.height -
                  64);
        },
      ),
      comments.length > 0
          ? ListView.builder(
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: (con, ind) {
                return Text.rich(
                  TextSpan(
                      text: '',
                      children: comments[ind].split(' ').map((w) {
                        return w.startsWith('@') && w.length > 1
                            ? TextSpan(
                                text: ' ' + w,
                                style: TextStyle(color: Colors.blue),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () => showProfile(w),
                              )
                            : TextSpan(
                                text: ' ' + w,
                                style: TextStyle(color: Colors.black));
                      }).toList()),
                );
              },
            )
          : SizedBox()
    ]);
  }

  showProfile(String s) {
    showDialog(
        context: context,
        builder: (con) => AlertDialog(
            title: Text('Profile of $s'),
            content: Text('Show the user profile !')));
  }
}
