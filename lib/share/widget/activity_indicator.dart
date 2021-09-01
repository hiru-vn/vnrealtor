import 'package:flutter/cupertino.dart';

import '../import.dart';

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
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff293079),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
