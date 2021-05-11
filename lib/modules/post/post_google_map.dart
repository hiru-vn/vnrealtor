import 'dart:typed_data';

import 'package:datcao/share/widget/keep_keyboard_popup_menu/keep_keyboard_popup_menu.dart';
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
      zoom: 18,
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
        bearing: 0, target: LatLng(widget.lat, widget.long), tilt: 0, zoom: 18);
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
    final List<double> edges = [];
    for (int i = 0; i < widget.polygonPoints.length; i++) {
      var coor1 = widget.polygonPoints[i];
      var coor2 = (i == widget.polygonPoints.length - 1)
          ? widget.polygonPoints[0]
          : widget.polygonPoints[i + 1];
      edges.add(getCoordinateDistanceInKm(coor1, coor2) * 1000);
    }
    final double perimeter = edges.fold(0, (e1, e2) => e1 + e2);
    final double area = getAreaInMeter(widget.polygonPoints);

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            buildingsEnabled: false,
            tiltGesturesEnabled: false,
            mapType: MapType.hybrid,
            initialCameraPosition: _initPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: (widget.polygonPoints != null &&
                    (widget.polygonPoints.length > 0)
                ? widget.polygonPoints
                    .map((e) => Marker(
                          markerId: MarkerId(e.toString()),
                          position: e,
                          icon: BitmapDescriptor.fromBytes(
                              markerIcon[widget.polygonPoints.indexOf(e)]),
                        ))
                    .toSet()
                : (selectedMarker != null ? <Marker>{selectedMarker} : null)),
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
                    ),
                  }
                : null),
          ),
          if (widget.polygonPoints != null && widget.polygonPoints.length > 2)
            Positioned(
                top: 80,
                right: 10,
                child: WithKeepKeyboardPopupMenu(
                    backgroundBuilder: (context, widget) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.yellow, width: 0.75),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black45,
                        ),
                        child:
                            Material(color: Colors.transparent, child: widget)),
                    calculatePopupPosition:
                        (Size menuSize, Rect overlayRect, Rect buttonRect) {
                      return Offset(buttonRect.left - menuSize.width - 7,
                          menuSize.height);
                    },
                    menuBuilder: (context, closePopup) {
                      return GestureDetector(
                        onTap: () {
                          closePopup();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...widget.polygonPoints.map((e) {
                                final index = widget.polygonPoints.indexOf(e);
                                return Text(
                                  'Từ ${index + 1} đến ${index == widget.polygonPoints.length - 1 ? '1' : index + 2}: ${edges[index].toStringAsFixed(1)} m',
                                  style:
                                      ptBody().copyWith(color: Colors.yellow),
                                );
                              }),
                              // Divider(
                              //   height: 8,
                              // ),
                              // Text('Chu vi: ${perimeter.round()} m'),
                              // Text('Diện tích: ${area.round()} m2'),
                            ],
                          ),
                        ),
                      );
                    },
                    childBuilder: (context, openPopup, closePopup) => Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(21),
                          elevation: 0,
                          child: GestureDetector(
                            onTap: () {
                              openPopup();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black38,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.info_outline,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ))),

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
          if (widget.polygonPoints.length > 2)
            Positioned(
              right: 60,
              bottom: 18,
              child: Center(
                child: Column(
                  children: [
                    Text('Số điểm dấu: ${widget.polygonPoints.length}',
                        style: ptBody().copyWith(color: Colors.yellow)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.yellow, width: 0.75),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black45,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Chu vi',
                                      style: ptBody()
                                          .copyWith(color: Colors.yellow),
                                    ),
                                    Text('${perimeter.round()} m',
                                        style: ptTitle()
                                            .copyWith(color: Colors.yellow)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 45,
                                width: 0.75,
                                color: Colors.yellow,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      'Diện tích',
                                      style: ptBody()
                                          .copyWith(color: Colors.yellow),
                                    ),
                                    Text('${area.round()} m2',
                                        style: ptTitle()
                                            .copyWith(color: Colors.yellow)),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                      Text('Mở GoogleMap')
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
