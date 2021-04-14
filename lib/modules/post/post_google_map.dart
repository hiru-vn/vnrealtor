import 'package:flutter/material.dart';
import 'dart:async';
import 'package:datcao/share/import.dart';
import 'package:url_launcher/url_launcher.dart';

Future showGoogleMapPoint(
    BuildContext context, double lat, double long, List<LatLng> polygonPoints,
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
              polygonPoints: polygonPoints,
            ));
      });
}

class GoogleMapWidget extends StatefulWidget {
  final double lat, long;
  final List<LatLng> polygonPoints;

  const GoogleMapWidget({Key key, this.lat, this.long, this.polygonPoints})
      : super(key: key);
  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initPos;
  Marker selectedMarker;
  LatLng selectedPoint;

  @override
  void initState() {
    _initPos = CameraPosition(
      target: LatLng(widget.lat, widget.long),
      zoom: 15,
    );
    selectedPoint = LatLng(widget.lat, widget.long);
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

  _launchMap(LatLng pos) async {
    if (pos == null) {
      showToast('Chưa chọn toạ độ', context);
      return;
    }
    var mapSchema = 'geo:${pos.latitude},${pos.longitude}';
    if (await canLaunch(mapSchema)) {
      await launch(mapSchema);
    } else {
      throw 'Could not launch $mapSchema';
    }
  }

  // _onSearch(double lat, double long, String name) async {
  //   selectedMarker = Marker(
  //     markerId: MarkerId(LatLng(lat, long).toString()),
  //     position: LatLng(lat, long),
  //     infoWindow: InfoWindow(
  //       title: name,
  //     ),
  //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //   );

  //   CameraPosition _curPos = CameraPosition(
  //       bearing: 0, target: LatLng(lat, long), tilt: 0, zoom: 15);
  //   final GoogleMapController controller = await _controller.future;
  //   controller.moveCamera(CameraUpdate.newCameraPosition(_curPos));
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
            markers: selectedMarker != null ? <Marker>{selectedMarker} : null,
            polygons: (widget.polygonPoints != null &&
                    (widget.polygonPoints.length > 0)
                ? <Polygon>{
                    Polygon(
                      polygonId: PolygonId('PolygonId'),
                      points: widget.polygonPoints,
                      consumeTapEvents: true,
                      strokeColor: Colors.redAccent,
                      strokeWidth: 1,
                      fillColor: Colors.redAccent.withOpacity(0.5),
                    )
                  }
                : null),
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
          // CustomFloatingSearchBar(
          //   onSearch: _onSearch,
          // ),
          Positioned(
            bottom: 15,
            left: 12,
            child: InkWell(
              onTap: () => _launchMap(selectedPoint),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  height: 40,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.map_outlined,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Mở trong Google Map')
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
