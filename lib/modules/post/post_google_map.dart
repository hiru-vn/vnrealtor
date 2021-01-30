import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:vnrealtor/share/import.dart';

Future showGoogleMapPoint(BuildContext context, double lat, double long,
    {double height}) {
  if (height == null)
    height = MediaQuery.of(context).size.height - kToolbarHeight;
  return showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) {
        return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: height,
            child: GoogleMapWidget(
              lat: lat,
              long: long,
            ));
      });
}

class GoogleMapWidget extends StatefulWidget {
  final double lat, long;

  const GoogleMapWidget({Key key, this.lat, this.long}) : super(key: key);
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initPos;
  Marker selectedMarker;

  @override
  void initState() {
    _initPos = CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: 15,
    );
    super.initState();

    selectedMarker = Marker(
      markerId: MarkerId(LatLng(widget.lat, widget.long).toString()),
      position: LatLng(widget.lat, widget.long),
      infoWindow: InfoWindow(
        title: 'Ví trí đang chọn',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    _cameraMove();
  }

  _cameraMove() async {
    CameraPosition _curPos = CameraPosition(
        bearing: 0, target: LatLng(widget.lat, widget.long), tilt: 0, zoom: 15);
    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(_curPos));
  }

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
        ],
      ),
    );
  }
}
