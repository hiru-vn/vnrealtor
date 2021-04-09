import 'package:flutter/cupertino.dart';

class ActivityIndicator extends StatelessWidget {

  const ActivityIndicator();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CupertinoActivityIndicator(),
          ),
          Text(
            'Loading...',
          ),
        ],
      ),
    );
  }
}
