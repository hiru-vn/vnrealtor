import 'dart:async';
import 'dart:math';

import 'package:datcao/modules/bloc/post_bloc.dart';
import 'package:datcao/modules/model/post.dart';
import 'package:datcao/modules/post/post_detail.dart';
import 'package:datcao/share/import.dart';
import 'package:datcao/share/widget/map_drawer.dart';

class PostMap extends StatefulWidget {
  @override
  State<PostMap> createState() => PostMapState();
}

class PostMapState extends State<PostMap> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _initPos = CameraPosition(
    target: LatLng(16.04, 108.19),
    zoom: 5,
  );
  PostBloc? _postBloc;
  LatLng? _lastMapPosition;
  LatLng? _currentMapPosition; // center of map
  double distance = 30; //km
  List<PostModel>? posts = [];
  Set<Marker> selectedMarkers = <Marker>{};
  InfoWidgetRoute? _infoWidgetRoute;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  void initState() {
    super.initState();
    _getInitPosPrefs();
    getDevicePosition().then((value) async {
      _lastMapPosition = LatLng(value.latitude, value.longitude);
      _currentMapPosition = LatLng(value.latitude, value.longitude);
      CameraPosition _curPos = CameraPosition(
          bearing: 0,
          target: LatLng(value.latitude, value.longitude),
          tilt: 0,
          zoom: 15);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(_curPos));
      _getPostLocal();
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos as double Function(num?);
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    // print(12742 * asin(sqrt(a)));
    return 12742 * asin(sqrt(a));
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapPosition = position.target;
    if (calculateDistance(
            _currentMapPosition!.latitude,
            _currentMapPosition!.longitude,
            _lastMapPosition!.latitude,
            _lastMapPosition!.longitude) >
        (distance * 0.5)) {
      _lastMapPosition = _currentMapPosition;
      _getPostLocal();
    }
    // _controller.future.then((value) async {
    //   final zoom = await value.getZoomLevel();
    //   distance = pow(2, 15 - zoom) * 10;
    //   print('distance:' + distance.toString());
    // });
  }

  @override
  void didChangeDependencies() {
    if (_postBloc == null) {
      _postBloc = Provider.of<PostBloc>(context);
    }
    super.didChangeDependencies();
  }

  _getPostLocal() async {
    final res = await _postBloc!.searchPostWithLocation(
        _lastMapPosition!.longitude, _lastMapPosition!.latitude, distance);
    if (res.isSuccess) {
      posts = res.data;
      selectedMarkers.clear();
      posts!.forEach((element) {
        Marker marker = Marker(
          markerId: MarkerId(element.id!),
          position: LatLng(element.locationLat!, element.locationLong!),
          // infoWindow: InfoWindow(
          //   title: element.content.trim().length > 40
          //       ? (element.content.trim().substring(0, 37) + '...')
          //       : element.content.trim(),
          //   onTap: () => PostDetail.navigate(null, postId: element.id),
          // ),
          onTap: () => _controller.future.then(
            (c) => _onTapMarker(PointObject(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      element.content!.trim().length > 40
                          ? (element.content!.trim().substring(0, 37) + '...')
                          : element.content!.trim(),
                      maxLines: 2,
                    ),
                    GestureDetector(
                      onTap: () {
                        PostDetail.navigate(null, postId: element.id);
                        audioCache.play('tab3.mp3');
                      },
                      child: SizedBox(
                        height: 25,
                        child: Center(
                          child: Text(
                            'Xem bài viết >>',
                            style: ptSmall().copyWith(color: Colors.blue),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                location: LatLng(element.locationLat!, element.locationLong!))),
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        selectedMarkers.add(marker);
        setState(() {});
      });
    } else {
      showToast(res.errMessage, context);
    }
  }

  _onTapMarker(PointObject point) async {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    Rect _itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;

    _infoWidgetRoute = InfoWidgetRoute(
      child: point.child,
      buildContext: context,
      textStyle: const TextStyle(
        fontSize: 13,
        color: Colors.black,
      ),
      mapsWidgetSize: _itemRect,
    );

    Navigator.of(context, rootNavigator: true)
        .push(_infoWidgetRoute!)
        .then<void>(
      (newValue) {
        _infoWidgetRoute = null;
      },
    );

    await (await _controller.future).animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          point.location!.latitude - 0.0001,
          point.location!.longitude,
        ),
      ),
    );
    await (await _controller.future).animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          point.location!.latitude - 0.0001,
          point.location!.longitude,
        ),
      ),
    );
  }

  _getInitPosPrefs() async {
    final double? lat = await SPref.instance.get('lat') as double?;
    final double? long = await SPref.instance.get('long') as double?;
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
          selectedMarkers.add(Marker(
            markerId: MarkerId('mylocation'),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(
              title: 'Ví trí của tôi',
            ),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          ));
          CameraPosition _curPos = CameraPosition(
              bearing: 0,
              target: LatLng(value.latitude, value.longitude),
              tilt: 0,
              zoom: 15);
          _controller.future.then((controller) => controller
              .animateCamera(CameraUpdate.newCameraPosition(_curPos)));
        }));
  }

  _onSearch(double? lat, double? long, String? name) async {
    selectedMarkers.add(Marker(
      markerId: MarkerId(LatLng(lat!, long!).toString()),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: name,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    setState(() {});

    CameraPosition _curPos = CameraPosition(
        bearing: 0, target: LatLng(lat, long), tilt: 0, zoom: 15);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_curPos));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: MapDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initPos,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onCameraMove: _onCameraMove,
            markers: selectedMarkers,
          ),
          CustomFloatingSearchBar(
            onSearch: _onSearch,
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
              ))
        ],
      ),
    );
  }
}

class _InfoWidgetRouteLayout<T> extends SingleChildLayoutDelegate {
  final Rect mapsWidgetSize;
  final double width;
  final double height;

  _InfoWidgetRouteLayout(
      {required this.mapsWidgetSize,
      required this.height,
      required this.width});

  /// Depending of the size of the marker or the widget, the offset in y direction has to be adjusted;
  /// If the appear to be of different size, the commented code can be uncommented and
  /// adjusted to get the right position of the Widget.
  /// Or better: Adjust the marker size based on the device pixel ratio!!!!)

  @override
  Offset getPositionForChild(Size size, Size childSize) {
//    if (Platform.isIOS) {
    return Offset(
      mapsWidgetSize.center.dx - childSize.width / 2,
      mapsWidgetSize.center.dy - childSize.height - 50,
    );
//    } else {
//      return Offset(
//        mapsWidgetSize.center.dx - childSize.width / 2,
//        mapsWidgetSize.center.dy - childSize.height - 10,
//      );
//    }
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //we expand the layout to our predefined sizes
    return BoxConstraints.expand(width: width, height: height);
  }

  @override
  bool shouldRelayout(_InfoWidgetRouteLayout oldDelegate) {
    return mapsWidgetSize != oldDelegate.mapsWidgetSize;
  }
}

class InfoWidgetRoute extends PopupRoute {
  final Widget? child;
  final double width;
  final double height;
  final BuildContext buildContext;
  final TextStyle textStyle;
  final Rect mapsWidgetSize;

  InfoWidgetRoute({
    required this.child,
    required this.buildContext,
    required this.textStyle,
    required this.mapsWidgetSize,
    this.width = 150,
    this.height = 80,
    this.barrierLabel,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 100);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      removeTop: true,
      child: Builder(builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _InfoWidgetRouteLayout(
              mapsWidgetSize: mapsWidgetSize, width: width, height: height),
          child: InfoWidgetPopUp(
            infoWidgetRoute: this,
          ),
        );
      }),
    );
  }
}

class InfoWidgetPopUp extends StatefulWidget {
  const InfoWidgetPopUp({
    Key? key,
    required this.infoWidgetRoute,
  })  : assert(infoWidgetRoute != null),
        super(key: key);

  final InfoWidgetRoute infoWidgetRoute;

  @override
  _InfoWidgetPopUpState createState() => _InfoWidgetPopUpState();
}

class _InfoWidgetPopUpState extends State<InfoWidgetPopUp> {
  late CurvedAnimation _fadeOpacity;

  @override
  void initState() {
    super.initState();
    _fadeOpacity = CurvedAnimation(
      parent: widget.infoWidgetRoute.animation!,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: Material(
        type: MaterialType.transparency,
        textStyle: widget.infoWidgetRoute.textStyle,
        child: ClipPath(
          clipper: _InfoWidgetClipper(),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 10),
            child: Center(child: widget.infoWidgetRoute.child),
          ),
        ),
      ),
    );
  }
}

class _InfoWidgetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 20);
    path.quadraticBezierTo(0.0, size.height - 10, 10.0, size.height - 10);
    path.lineTo(size.width / 2 - 10, size.height - 10);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width / 2 + 10, size.height - 10);
    path.lineTo(size.width - 10, size.height - 10);
    path.quadraticBezierTo(
        size.width, size.height - 10, size.width, size.height - 20);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(10, 0.0);
    path.quadraticBezierTo(0.0, 0.0, 0.0, 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PointObject {
  final Widget? child;
  final LatLng? location;

  PointObject({this.child, this.location});
}
