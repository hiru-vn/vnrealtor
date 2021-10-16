// import 'package:flutter/material.dart';
// import 'package:flutter_callkeep/flutter_callkeep.dart';

// class CallKit {
//   static Future<void> displayIncomingCall(
//       BuildContext context, String uid, String name, String number) async {
//     await CallKeep.askForPermissionsIfNeeded(context);

//     await CallKeep.displayIncomingCall(
//         uid, name, number, HandleType.number, false);

//     Future.delayed(Duration(seconds: 10), () {
//       CallKeep.endCall(uid);
//     });
//   }
// }
