import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

navigateToGoogleMap(double lat, double lng) async {
  var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

launchCaller(String number) async {
  String url = "tel:$number";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
