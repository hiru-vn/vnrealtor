import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:datcao/share/import.dart';
import 'dart:io' show Platform;
import '../../share/widget/keep_keyboard_popup_menu/keep_keyboard_popup_menu.dart';

class PickCoordinates extends StatefulWidget {
  final bool hasPolygon;
  final LatLng position;
  final List<LatLng> polygon;

  const PickCoordinates(
      {Key key, this.hasPolygon = true, this.position, this.polygon})
      : super(key: key);
  static Future navigate(
      {bool hasPolygon = true, LatLng position, List<LatLng> polygon}) {
    return navigatorKey.currentState.push(pageBuilder(PickCoordinates(
      hasPolygon: hasPolygon,
      polygon: polygon.length > 0 ? polygon : null,
      position: position,
    )));
  }

  @override
  State<PickCoordinates> createState() => PickCoordinatesState();
}

class PickCoordinatesState extends State<PickCoordinates>
    with SingleTickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initPos = CameraPosition(
    target: LatLng(16.04, 108.19),
    zoom: 5,
  );
  Marker selectedMarker;
  String _placeName;
  String _mode = 'point';
  List<LatLng> polygonPoints = [];
  LatLng center;
  Function _openPopup;
  bool readedInstructionPolygon = false;
  AnimationController animationController;

  @override
  void initState() {
    if (widget.position != null) {
      Future.delayed(
          Duration(milliseconds: 500), () => _selectMarker(widget.position));
    }
    if (widget.polygon != null) {
      polygonPoints = widget.polygon;
      _mode = 'polygon';
    }
    _getInitPosPrefs();
    getDevicePosition().then((value) async {
      CameraPosition _curPos = CameraPosition(
          bearing: 0,
          target: LatLng(value.latitude, value.longitude),
          tilt: 0,
          zoom: 17);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_curPos));
    });
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animationController.forward();
            }
          })
          ..forward();
    super.initState();
  }

  void _selectMarker(LatLng point) {
    setState(() {
      selectedMarker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow:
            InfoWindow(title: 'Ví trí đang chọn', snippet: 'Đang tìm kiếm...'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });

    Future.delayed(Duration(milliseconds: 150), () {
      _controller.future.then(
          (value) => value.showMarkerInfoWindow(MarkerId(point.toString())));
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
      polygonPoints.add(point);
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (polygonPoints.length > 2 && _openPopup != null) _openPopup();
    // });

    final center = getCenterCoordinate(polygonPoints);
    PostBloc.instance.getAddress(center.longitude, center.latitude).then((res) {
      if (res.isSuccess) {
        setState(() {
          _placeName = res.data.address;
        });
      }
    });
  }

  Future<LatLng> getCenter() async {
    final GoogleMapController controller = await _controller.future;
    LatLngBounds visibleRegion = await controller.getVisibleRegion();
    LatLng centerLatLng = LatLng(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );
    center = centerLatLng;

    return centerLatLng;
  }

  void _redoMarkerPoligon() {
    setState(() {
      polygonPoints.remove(polygonPoints[polygonPoints.length - 1]);
    });

    if (polygonPoints.length < 1) return;
    final center = getCenterCoordinate(polygonPoints);
    PostBloc.instance.getAddress(center.longitude, center.latitude).then((res) {
      if (res.isSuccess) {
        setState(() {
          _placeName = res.data.address;
        });
      }
    });
  }

  void _clearMarkerPoligon() {
    setState(() {
      polygonPoints.clear();
    });
  }

  void _selectMyLocation() {
    getDevicePosition().then((value) {
      setState(() {
        if (_mode == 'point')
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
        _controller.future.then((controller) =>
            controller.animateCamera(CameraUpdate.newCameraPosition(_curPos)));
      });
    });
  }

  _getInitPosPrefs() async {
    final double lat = await SPref.instance.get('lat') as double;
    final double long = await SPref.instance.get('long') as double;
    if (lat != null && long != null) {
      CameraPosition _lastSavedPos = CameraPosition(
          bearing: 0, target: LatLng(lat, long), tilt: 0, zoom: 17);
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
    final List<double> edges = [];

    for (int i = 0; i < polygonPoints.length; i++) {
      var coor1 = polygonPoints[i];
      var coor2 = (i == polygonPoints.length - 1)
          ? polygonPoints[0]
          : polygonPoints[i + 1];
      edges.add(getCoordinateDistanceInKm(coor1, coor2) * 1000);
    }

    final double perimeter = edges.fold(0, (e1, e2) => e1 + e2);

    final double area = getAreaInMeter(polygonPoints);
    final shouldShowInstructionPolygon = _mode == 'polygon' &&
        polygonPoints.length == 0 &&
        !readedInstructionPolygon;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            buildingsEnabled: false,
            tiltGesturesEnabled: false,
            mapType: MapType.hybrid,
            initialCameraPosition: _initPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: (_) {
              if (_mode == 'polygon' && polygonPoints.length > 0) {
                getCenter().then((value) => setState(() {}));
              }
            },
            polylines:
                _mode == 'polygon' && polygonPoints.length > 0 && center != null
                    ? <Polyline>{
                        Polyline(
                            color: Colors.red,
                            width: 1,
                            polylineId: PolylineId('PolylineId'),
                            points: <LatLng>[
                              center,
                              polygonPoints[polygonPoints.length - 1]
                            ])
                      }
                    : null,
            onTap: _mode == 'point' ? _selectMarker : (LatLng _) {},
            markers: _mode == 'point'
                ? (selectedMarker != null ? <Marker>{selectedMarker} : null)
                : (polygonPoints
                    .map((e) => Marker(
                          markerId: MarkerId(e.toString()),
                          position: e,
                          icon: BitmapDescriptor.fromBytes(
                              markerIcon[polygonPoints.indexOf(e)]),
                        ))
                    .toSet()),
            polygons: (_mode == 'polygon' && polygonPoints.length > 0)
                ? <Polygon>{
                    Polygon(
                      polygonId: PolygonId('PolygonId'),
                      points: polygonPoints,
                      consumeTapEvents: false,
                      strokeColor: Colors.redAccent,
                      strokeWidth: 1,
                      fillColor: Colors.redAccent.withOpacity(0.5),
                    )
                  }
                : null,
          ),
          CustomFloatingSearchBar(
            onSearch: _onSearch,
            automaticallyImplyBackButton: true,
            //   actions: [
            //     if (widget.hasPolygon ?? false)
            //       FloatingSearchBarAction(
            //         showIfOpened: false,
            //         child: PopupMenuButton(
            //           padding: EdgeInsets.zero,
            //           itemBuilder: (_) => <PopupMenuItem<String>>[
            //             PopupMenuItem(
            //               height: 36,
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text('Đánh vị trí'),
            //                   if (_mode == 'point') Icon(Icons.check),
            //                 ],
            //               ),
            //               value: 'point',
            //             ),
            //             PopupMenuItem(
            //               height: 36,
            //               child: Row(
            //                 mainAxisSize: MainAxisSize.min,
            //                 children: [
            //                   Text('Mô phỏng diện tích'),
            //                   if (_mode == 'polygon') Icon(Icons.check),
            //                 ],
            //               ),
            //               value: 'polygon',
            //             )
            //           ],
            //           onSelected: (val) {
            //             if (_mode != val)
            //               setState(() {
            //                 _mode = val;
            //               });
            //           },
            //           child: SizedBox(
            //             child: Align(
            //                 alignment: Alignment.centerRight,
            //                 child: Icon(Icons.more_vert)),
            //             height: 45,
            //             width: 30,
            //           ),
            //         ),
            //       ),
            //   ],
          ),
          Positioned(
              bottom: 180,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(21),
                      elevation: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _mode = 'point';
                          });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mode == 'point'
                                ? ptPrimaryColor(context)
                                : Colors.white,
                          ),
                          child: Center(
                            child: Icon(MdiIcons.mapMarker,
                                color: _mode == 'point'
                                    ? Colors.white
                                    : ptPrimaryColor(context)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(21),
                      elevation: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _mode = 'polygon';
                          });
                        },
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _mode == 'polygon'
                                ? ptPrimaryColor(context)
                                : Colors.white,
                          ),
                          child: Center(
                            child: Icon(MdiIcons.vectorPolygon,
                                color: _mode == 'polygon'
                                    ? Colors.white
                                    : ptPrimaryColor(context)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Positioned(
            bottom: 15,
            left: 12,
            child: InkWell(
              onTap: () async {
                if (selectedMarker == null && polygonPoints.length == 0) {
                  showToast('Chạm để chọn vị trí hoặc diện tích', context);
                  return;
                }
                navigatorKey.currentState.maybePop(
                    [selectedMarker?.position, _placeName, polygonPoints]);
              },
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: ptPrimaryColor(context),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 40,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Lưu vị trí này',
                        style: ptBody().copyWith(color: Colors.white),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (!Platform.isIOS)
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
                )),
          if (_mode == 'polygon' && polygonPoints.length > 2)
            Positioned(
                top: 100,
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
                              ...polygonPoints.map((e) {
                                final index = polygonPoints.indexOf(e);
                                return Text(
                                  'Từ ${index + 1} đến ${index == polygonPoints.length - 1 ? '1' : index + 2}: ${edges[index].toStringAsFixed(1)} m',
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
                    childBuilder: (context, openPopup, closePopup) {
                      _openPopup = openPopup;
                      return Material(
                        borderRadius: BorderRadius.circular(21),
                        elevation: 4,
                        child: GestureDetector(
                          onTap: () {
                            openPopup();
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
                                Icons.info_outline,
                                color: ptPrimaryColor(context),
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      );
                    })),
          if (_mode == 'polygon' && polygonPoints.length > 0) ...[
            Positioned(
                top: 160,
                right: 10,
                child: Material(
                  borderRadius: BorderRadius.circular(21),
                  elevation: 4,
                  child: GestureDetector(
                    onTap: _clearMarkerPoligon,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.clear,
                          color: ptPrimaryColor(context),
                        ),
                      ),
                    ),
                  ),
                )),
            if (_mode == 'polygon' && polygonPoints.length > 2)
              Positioned(
                right: 60,
                bottom: 18,
                child: Center(
                  child: Column(
                    children: [
                      Text('Số điểm dấu: ${polygonPoints.length}',
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
                top: 220,
                right: 10,
                child: Material(
                  borderRadius: BorderRadius.circular(21),
                  elevation: 4,
                  child: GestureDetector(
                    onTap: _redoMarkerPoligon,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.redo,
                          color: ptPrimaryColor(context),
                        ),
                      ),
                    ),
                  ),
                )),
          ],
          if (_mode == 'polygon') ...[
            Center(
              child: Icon(MdiIcons.target, size: 50, color: Colors.white),
            ),
            Positioned(
                top: 280,
                right: 10,
                child: Material(
                  borderRadius: BorderRadius.circular(21),
                  elevation: 4,
                  child: GestureDetector(
                    onTap: () async {
                      final center = await getCenter();
                      _addMarkerPoligon(center);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ptPrimaryColor(context),
                      ),
                      child: Center(
                        child: Icon(MdiIcons.vectorPolylinePlus,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )),
            if (polygonPoints.length > 0)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 80.0),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black54),
                  child: Text(
                    '${() {
                      final distance = getCoordinateDistanceInKm(
                          polygonPoints[polygonPoints.length - 1], center);
                      return (distance * 1000).toStringAsFixed(1);
                    }()} m',
                    style: ptBody().copyWith(color: Colors.white),
                  ),
                ),
              ),
          ],
          if (shouldShowInstructionPolygon) ...[
            IgnorePointer(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.black45,
                    BlendMode.srcOut), // This one will create the magic
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          backgroundBlendMode: BlendMode
                              .dstOut), // This one will handle background + difference out
                    ),
                    Positioned(
                      top: 270,
                      right: 0,
                      width: 64,
                      height: 64,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape
                                .circle), // This one will handle background + difference out
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape
                                .circle), // This one will handle background + difference out
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                right: 15,
                top: 240,
                child: ScaleTransition(
                    scale: Tween(
                      begin: 0.9,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeInCubic,
                    )),
                    child: Text(
                      '2. Nhấn để chọn điểm',
                      style: ptTitle().copyWith(
                        color: Colors.white,
                      ),
                    ))),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 110.0),
                child: ScaleTransition(
                    scale: Tween(
                      begin: 0.9,
                      end: 1.0,
                    ).animate(CurvedAnimation(
                      parent: animationController,
                      curve: Curves.easeInCubic,
                    )),
                    child: Text(
                      '1. Di chuyển bản đồ\nđể căn điểm',
                      style: ptTitle().copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    )),
              ),
            ),
            Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 140.0),
                    child: FlatButton(
                      child: Text(
                        'Đã hiểu',
                      ),
                      color: Colors.black54,
                      onPressed: () {
                        setState(() {
                          readedInstructionPolygon = true;
                        });
                      },
                    )))
          ]
        ],
      ),
    );
  }
}
