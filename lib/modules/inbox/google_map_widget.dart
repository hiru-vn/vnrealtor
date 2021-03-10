import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:datcao/modules/inbox/import/file_util.dart';
import 'package:datcao/navigator.dart';
import 'package:datcao/share/function/show_toast.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/utils/spref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

Future showGoogleMap(BuildContext context, {double height}) {
  if (height == null)
    height = MediaQuery.of(context).size.height - kToolbarHeight;
  return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return SizedBox(
            height: height,
            width: deviceWidth(context),
            child: GoogleMapWidget());
      });
}

GlobalKey mapKey = GlobalKey();

class GoogleMapWidget extends StatefulWidget {
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initPos = CameraPosition(
    target: LatLng(16.04, 108.19),
    zoom: 5,
  );
  Marker selectedMarker;
  LatLng selectedPoint;
  Uint8List pngBytes;

  Future<Uint8List> _getSnapShot() async {
    final imageBytes = await (await _controller?.future).takeSnapshot();
    setState(() {
      pngBytes = imageBytes;
    });

    return pngBytes;
  }

  void _selectMarker(LatLng point) {
    setState(() {
      selectedPoint = point;
      selectedMarker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Ví trí đang chọn',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
    Future.delayed(Duration(milliseconds: 100), () {
      _getSnapShot();
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitPosPrefs();
    _getDevicePosition().then((value) async {
      CameraPosition _curPos = CameraPosition(
          bearing: 0,
          target: LatLng(value.latitude, value.longitude),
          tilt: 0,
          zoom: 15);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_curPos));
    });
  }

  Future<Position> _getDevicePosition() async {
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

  _getInitPosPrefs() async {
    final double lat = await SPref.instance.get('lat') as double;
    final double long = await SPref.instance.get('long') as double;
    if (lat != null && long != null) {
      CameraPosition _lastSavedPos = CameraPosition(
          bearing: 0, target: LatLng(lat, long), tilt: 0, zoom: 15);
      final GoogleMapController controller = await _controller.future;
      controller.moveCamera(
        CameraUpdate.newCameraPosition(_lastSavedPos),
      );
    }
  }

  // _share() {
  //   Share.share(
  //       'https://www.google.com/maps/search/?api=1&query=${86.8},${86.8}');
  // }

  // _launchMap(LatLng pos) async {
  //   if (pos == null) {
  //     showToast('Chưa chọn toạ độ', context);
  //     return;
  //   }
  //   var mapSchema = 'geo:${pos.latitude},${pos.longitude}';
  //   if (await canLaunch(mapSchema)) {
  //     await launch(mapSchema);
  //   } else {
  //     throw 'Could not launch $mapSchema';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: _selectMarker,
            markers: selectedMarker != null ? <Marker>{selectedMarker} : null,
          ),
          Positioned(
            top: 20,
            right: 12,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 12,
            child: InkWell(
              onTap: () => Navigator.of(context).maybePop(),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 12,
            child: InkWell(
              onTap: () async {
                if (selectedPoint == null) {
                  showToast('Chạm để chọn vị trí', context);
                  return;
                }
                final file =
                    await FileUtil.writeToFile(pngBytes, 'map', 'jpeg');
                navigatorKey.currentState.maybePop([selectedPoint, file]);
              },
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 40,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Gửi vị trí đến tin nhắn')
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
