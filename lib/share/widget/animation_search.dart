import 'package:datcao/themes/font.dart';
import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final double width;
  final double height;
  final String value;
  final Function(String) onSearch;
  final Function(String) onSubmit;
  final TextEditingController controller;

  const AnimatedSearchBar(
      {Key key,
      this.width,
      this.height,
      this.onSearch,
      this.onSubmit,
      this.value,
      this.controller})
      : super(key: key);

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _folded = true;
  FocusNode _focusNode = FocusNode();
  double _width = 180;
  double _height = 48;

  @override
  void initState() {
    _width = widget.width ?? 180;
    _height = widget.height ?? 48;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _folded = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: _folded ? _height : _width,
      height: _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_height / 2),
        border: _folded
            ? null
            : Border.all(color: Theme.of(context).primaryColorDark),
        // boxShadow: _folded ? null : kElevationToShadow[1],
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 12),
              child: !_folded
                  ? TextField(
                      onChanged: widget.onSearch,
                      onSubmitted: widget.onSubmit,
                      controller: widget.controller,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                          hintText: 'Tìm kiếm',
                          hintStyle: ptTitle(),
                          border: InputBorder.none),
                    )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? _height / 2 : 0),
                  topRight: Radius.circular(_height / 2),
                  bottomLeft: Radius.circular(_folded ? _height / 2 : 0),
                  bottomRight: Radius.circular(24),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 12.0, top: 10, bottom: 10),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                  // Future.delayed(Duration(milliseconds: 300), () {
                  //   _focusNode.requestFocus();
                  // });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
