import 'dart:typed_data';

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
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: GoogleMapWidget());
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

  Future _onSearch(double lat, double long, String name) async {
    selectedMarker = Marker(
      markerId: MarkerId(LatLng(lat, long).toString()),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: name,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    CameraPosition _curPos = CameraPosition(
        bearing: 0, target: LatLng(lat, long), tilt: 0, zoom: 15);
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(_curPos));
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
      selectedPoint = LatLng(value.latitude, value.longitude);
      selectedMarker = Marker(
        markerId: MarkerId(LatLng(value.latitude, value.longitude).toString()),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(
          title: 'Ví trí của tôi',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      Future.delayed(Duration(milliseconds: 100), () {
        _getSnapShot();
      });
      setState(() {});
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
      showToast('Ứng dụng không thể truy cập vị trí của bạn', context);
      return Position(
          accuracy: 0.0,
          timestamp: DateTime.now(),
          speed: 0.0,
          heading: .0,
          speedAccuracy: .0,
          altitude: .0,
          latitude: 10.738381363037085,
          longitude: 106.68763584916785);
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        showToast('Ứng dụng không thể truy cập vị trí của bạn', context);
        return Position(
            accuracy: 0.0,
            timestamp: DateTime.now(),
            speed: 0.0,
            heading: .0,
            speedAccuracy: .0,
            altitude: .0,
            latitude: 10.738381363037085,
            longitude: 106.68763584916785);
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

  void _selectMyLocation() {
    getDevicePosition().then((value) => setState(() {
          selectedMarker = Marker(
            markerId: MarkerId(value.toString()),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(
              title: 'Ví trí của tôi',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
          CameraPosition _curPos = CameraPosition(
              bearing: 0,
              target: LatLng(value.latitude, value.longitude),
              tilt: 0,
              zoom: 15);
          _controller.future.then((controller) => controller
              .animateCamera(CameraUpdate.newCameraPosition(_curPos)));
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: CustomFloatingSearchBar(
            onSearch: _onSearch,
            automaticallyImplyBackButton: true,
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
                  await FileUtil.writeToFile(pngBytes, 'map', 'jpeg', 360);
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
        Positioned(
          bottom: 120,
          right: 10,
          child: Material(
            borderRadius: BorderRadius.circular(21),
            elevation: 4,
            child: GestureDetector(
              onTap: () {
                _selectMyLocation();
                audioCache.play('tab3.mp3');
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Icon(
                    Icons.my_location,
                    color: ptPrimaryColor(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
