import 'dart:async';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datcao/share/import.dart';

class PickCoordinates extends StatefulWidget {
  static Future navigate() {
    return navigatorKey.currentState.push(pageBuilder(PickCoordinates()));
  }

  @override
  State<PickCoordinates> createState() => PickCoordinatesState();
}

class PickCoordinatesState extends State<PickCoordinates> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initPos = CameraPosition(
    target: LatLng(16.04, 108.19),
    zoom: 5,
  );
  Marker selectedMarker;

  void _selectMarker(LatLng point) {
    setState(() {
      selectedMarker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Ví trí đang chọn',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitPosPrefs();
    getDevicePosition().then((value) async {
      CameraPosition _curPos = CameraPosition(
          bearing: 0,
          target: LatLng(value.latitude, value.longitude),
          tilt: 0,
          zoom: 15);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_curPos));
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar2(
        'Nhấn để chọn điểm',
        actions: [
          GestureDetector(
            onTap: () {
              navigatorKey.currentState.maybePop(selectedMarker.position);
            },
            child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Text(
                    'OK',
                    style: ptTitle().copyWith(color: Colors.white),
                  ),
                )),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initPos,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              onTap: _selectMarker,
              markers: selectedMarker != null ? <Marker>{selectedMarker} : null,
            ),
          ),
        ],
      ),
    );
  }
}
