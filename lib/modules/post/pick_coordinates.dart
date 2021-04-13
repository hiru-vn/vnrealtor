import 'dart:async';
import 'dart:math';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:flutter/foundation.dart';
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
  String _placeName;
  String _mode = 'point';
  Polygon polygon = Polygon(
    polygonId: PolygonId('id'),
    points: <LatLng>[],
    consumeTapEvents: true,
    strokeColor: Colors.grey,
    strokeWidth: 1,
    fillColor: Colors.redAccent,
  );

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

    PostBloc.instance.getAddress(point.longitude, point.latitude).then((res) {
      if (res.isSuccess) {
        setState(() {
          _placeName = res.data.address;
          selectedMarker = Marker(
            markerId: MarkerId(point.toString()),
            position: point,
            infoWindow: InfoWindow(
              snippet: res.data.address.toString(),
              title: 'Ví trí đang chọn',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          );
        });
        Future.delayed(Duration(milliseconds: 150), () {
          _controller.future.then((value) =>
              value.showMarkerInfoWindow(MarkerId(point.toString())));
        });
      }
    });
  }

  void _addMarkerPoligon(LatLng point) {
    setState(() {
      polygon.points.add(point);
    });
  }

  void _redoMarkerPoligon(LatLng point) {
    setState(() {
      polygon.points.remove(polygon.points[polygon.points.length - 1]);
    });
  }

  void _clearMarkerPoligon(LatLng point) {
    setState(() {
      polygon.points.remove(polygon.points[polygon.points.length - 1]);
    });
  }

  void _selectMyLocation() {
    getDevicePosition().then((value) => setState(() {
          if (_mode == 'point')
            selectedMarker = Marker(
              markerId: MarkerId(value.toString()),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: InfoWindow(
                title: 'Ví trí của tôi',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
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

  _onSearch(double lat, double long, String name) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: _mode == 'point' ? _selectMarker : _addMarkerPoligon,
            markers: selectedMarker != null ? <Marker>{selectedMarker} : null,
            polygons: <Polygon>{polygon},
          ),
          CustomFloatingSearchBar(
            onSearch: _onSearch,
            automaticallyImplyBackButton: true,
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: PopupMenuButton(
                  padding: EdgeInsets.zero,
                  itemBuilder: (_) => <PopupMenuItem<String>>[
                    PopupMenuItem(
                      height: 36,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Đánh vị trí'),
                          if (_mode == 'point') Icon(Icons.check),
                        ],
                      ),
                      value: 'point',
                    ),
                    PopupMenuItem(
                      height: 36,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Mô phỏng diện tích'),
                          if (_mode == 'poligon') Icon(Icons.check),
                        ],
                      ),
                      value: 'poligon',
                    )
                  ],
                  onSelected: (val) {
                    if (_mode != val)
                      setState(() {
                        _mode = val;
                      });
                  },
                  child: SizedBox(
                    child: const Icon(Icons.more_vert),
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 15,
            left: 12,
            child: InkWell(
              onTap: () async {
                if (selectedMarker == null) {
                  showToast('Chạm để chọn vị trí', context);
                  return;
                }
                navigatorKey.currentState
                    .maybePop([selectedMarker.position, _placeName]);
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
                      Text('Lưu vị trí này'),
                      SizedBox(
                        width: 3,
                      ),
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
                  onTap: _selectMyLocation,
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
              ))
        ],
      ),
    );
  }
}
