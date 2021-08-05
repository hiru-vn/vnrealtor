import 'package:datcao/modules/inbox/import/color.dart';
import 'package:datcao/modules/inbox/import/font.dart';
import 'package:datcao/modules/services/credential_key.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:dio/dio.dart';

class CustomFloatingSearchBar extends StatefulWidget {
  final Function(double lat, double long, String name) onSearch;
  final bool automaticallyImplyBackButton;
  final List<Widget> actions;

  const CustomFloatingSearchBar(
      {Key key, this.onSearch, this.automaticallyImplyBackButton = false, this.actions})
      : super(key: key);

  @override
  _CustomFloatingSearchBarState createState() =>
      _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
  List<PredictionPlace> _autoCompletePlaces = [];
  bool _isFocus = false;

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      hint: 'Tìm kiếm...',
      onFocusChanged: (isFocus) {
        setState(() {
          _isFocus = isFocus;
        });
      },
      automaticallyImplyBackButton: widget.automaticallyImplyBackButton,
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      debounceDelay: const Duration(milliseconds: 500),
      

      onQueryChanged: (query) async {
        if (query.trim() == '') {
          setState(() {
            _autoCompletePlaces.clear();
          });
          return;
        }
        String url =
            'https://maps.googleapis.com/maps/api/place/autocomplete/json';
        String request = url +
            '?input=$query&key=$places_api_key&language=vi&components=country:vn&types=(regions)';
        print(request);
        final response = await Dio().get(request);
        if (response.statusCode == 200) {
          final List list = response.data["predictions"];
          setState(() {
            _autoCompletePlaces = List<PredictionPlace>.generate(
              list.length,
              (index) => PredictionPlace.fromJson(list[index]),
            );
          });
        }
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
        if (widget.actions!=null) ...widget.actions
      ],
      builder: (context, transition) {
        return _autoCompletePlaces.length == 0 || !_isFocus
            ? SizedBox.shrink()
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Container(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _autoCompletePlaces.length,
                        separatorBuilder: (_, __) => Divider(
                              height: 1,
                              endIndent: 18,
                              indent: 55.0,
                            ),
                        itemBuilder: (context, index) => InkWell(
                              onTap: () async {
                                String url =
                                    'https://maps.googleapis.com/maps/api/place/details/json';
                                String request = url +
                                    '?place_id=${_autoCompletePlaces[index].placeId}&fields=name,geometry/location&key=$places_api_key';
                                print(request);
                                // setState(() {
                                //   _autoCompletePlaces.clear();
                                // });
                                final response = await Dio().get(request);
                                if (response.statusCode == 200) {
                                  final data = response.data["result"];
                                  final place = Place.fromJson(data);
                                  widget.onSearch(place.geometry.location.lat,
                                      place.geometry.location.lng, place.name);
                                  FloatingSearchBar.of(context).close();
                                }
                              },
                              child: Container(
                                height: 58,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 55,
                                      child: Container(
                                        height: 28,
                                        width: 28,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ptSecondaryColor(context),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.place,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      _autoCompletePlaces[index].description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: ptBody()
                                          .copyWith(color: Colors.black87),
                                    )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.chevron_right_rounded),
                                    SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  ),
                ),
              );
      },
    );
  }
}

class PredictionPlace {
  String description;
  String placeId;
  String reference;
  List<String> types;

  PredictionPlace({this.description, this.placeId, this.reference, this.types});

  PredictionPlace.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
    reference = json['reference'];
    types = json['types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    data['types'] = this.types;
    return data;
  }
}

class Place {
  Geometry geometry;
  String name;

  Place({this.geometry, this.name});

  Place.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['name'] = this.name;
    return data;
  }
}

class Geometry {
  Location location;

  Geometry({this.location});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  double lat;
  double lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
