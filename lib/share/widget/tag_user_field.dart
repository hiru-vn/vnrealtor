import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class TagUserField extends StatefulWidget {
  final TextEditingController controller;
  final List<String> users;
  final FocusNode focusNode;
  final Function(String) onSubmitted;
  final InputDecoration decoration;

  TagUserField(
      {this.controller,
      this.users,
      this.focusNode,
      this.onSubmitted,
      this.decoration});

  @override
  _TagUserFieldState createState() => _TagUserFieldState();
}

class _TagUserFieldState extends State<TagUserField> {
  List<String> words = [];
  List<String> comments = [];
  String str = '';

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(
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
              str = words.length > 0 && words[words.length - 1].startsWith('@')
                  ? words[words.length - 1]
                  : '';
            });
          }),
      str.length > 1
          ? ListView(
              shrinkWrap: true,
              children: widget.users.map((s) {
                if (('@' + s).contains(str))
                  return ListTile(
                      title: Text(
                        s,
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        String tmp = str.substring(1, str.length);
                        setState(() {
                          str = '';
                          widget.controller.text += s
                              .substring(s.indexOf(tmp) + tmp.length, s.length)
                              .replaceAll(' ', '_');
                        });
                      });
                else
                  return SizedBox();
              }).toList())
          : SizedBox(),
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
