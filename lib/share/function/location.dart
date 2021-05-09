import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:datcao/share/import.dart';
import 'package:geolocator/geolocator.dart';
import 'package:datcao/utils/spref.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> getDevicePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  final pos = await Geolocator.getCurrentPosition();
  SPref.instance.setDouble('lat', pos.latitude);
  SPref.instance.setDouble('long', pos.longitude);
  return pos;
}

double getCoordinateDistanceInKm(LatLng a, LatLng b) {
  var p = 0.017453292519943295; // Math.PI / 180
  var d = 0.5 -
      cos((b.latitude - a.latitude) * p) / 2 +
      cos(a.latitude * p) *
          cos(b.latitude * p) *
          (1 - cos((b.longitude - a.longitude) * p)) /
          2;

  return 12742 * asin(sqrt(d));
}

double getAreaInMeter(List<LatLng> coordinates) {
  num _area = 0;

  if (coordinates.length > 2) {
    for (int i = 0; i < coordinates.length; i++) {
      final x1 = coordinates[i].latitude;
      final y1 = coordinates[i].longitude;
      final x2 = i == coordinates.length - 1
          ? coordinates[0].latitude
          : coordinates[i + 1].latitude;
      final y2 = i == coordinates.length - 1
          ? coordinates[0].longitude
          : coordinates[i + 1].longitude;
      _area += (x1 * y2 - y1 * x2);
    }
  }

  return _area.abs() / 2 * 111320 * 111320;
}

LatLng getCenterCoordinate(List<LatLng> coordinates) {
  num sumX = 0;
  num sumY = 0;

  for (int i = 0; i < coordinates.length; i++) {
    sumX += coordinates[i].latitude;
    sumY += coordinates[i].longitude;
  }

  return LatLng(sumX / coordinates.length, sumY / coordinates.length);
}

Future<Uint8List> getBytesFromCanvas(
    int width, int height, String number) async {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = Colors.green;
  canvas.drawCircle(Offset(25, 25), 25, paint);
  TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
  painter.text = TextSpan(
    text: number,
    style: TextStyle(fontSize: 25.0, color: Colors.white),
  );
  painter.layout();
  painter.paint(canvas, Offset(18.0 - ((number.length - 1) * 7), 13));
  final img = await pictureRecorder.endRecording().toImage(width, height);
  final data = await img.toByteData(format: ImageByteFormat.png);
  return data.buffer.asUint8List();
}

void initMarkerIcon() {
  for (int i = 1; i < 30; i++) {
    getBytesFromCanvas(50, 50, i.toString()).then((value) {
      markerIcon.add(value);
    });
  }
}

List<Uint8List> markerIcon = [];
