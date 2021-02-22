
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl/src/trip.dart';

// ignore: must_be_immutable
class MapWithTrip extends StatefulWidget {

  List<Trip> tripData;
  String accessToken;
  String startIconPath;
  String endIconPath;
  Function(GpsLocation) tripPressCallback;
  Function() onStyleLoaded;

  MapWithTrip(List<Trip> trip, String token, String startIconPath, String endIconPath, Function(GpsLocation) callback, Function() styleLoaded) {
    this.tripData = trip;
    this.accessToken = token;
    this.tripPressCallback = callback;
    this.onStyleLoaded = styleLoaded;
    this.endIconPath = endIconPath;
    this.startIconPath = startIconPath;

  }

  @override
  State<StatefulWidget> createState() => MapWithTripState(this.tripData,this.accessToken, this.startIconPath, this.endIconPath, this.tripPressCallback, this.onStyleLoaded);
}

class MapWithTripState extends State<MapWithTrip> {

  List<Trip> tripData;
  String accessToken;
  String startIconPath;
  String endIconPath;
  Function(GpsLocation) tripPressCallback;
  Function() onStyleLoaded;

  MapWithTripState(List<Trip> trip, String token, String startIconPath, String endIconPath, Function(GpsLocation) callback, Function() styleLoaded) {
    this.tripData = trip;
    this.accessToken = token;
    this.tripPressCallback = callback;
    this.onStyleLoaded = styleLoaded;
    this.endIconPath = endIconPath;
    this.startIconPath = startIconPath;
  }

  int _symbolCount = 0;
  int eventCount = 0;
  Symbol _selectedSymbol;
  MapboxMapController controller;
  Line _selectedLine;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    //controller.onLineTapped.add(_onLineTapped);
  }

  /**
   * Here you specify which images / icons should be included on the map
   */
  Future<void> addImageFromAsset() async{
    final ByteData bytes = await rootBundle.load(this.startIconPath); // "assets/symbols/start.png"
    final Uint8List list = bytes.buffer.asUint8List();
    await controller.addImage("start", list);
    final ByteData bytes2 = await rootBundle.load(this.endIconPath); // "assets/symbols/stop.png"
    final Uint8List list2 = bytes2.buffer.asUint8List();
    await controller.addImage("stop", list2);

  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onEventTapped);
    //controller?.onLineTapped?.remove(_onLineTapped);
    super.dispose();
  }

  void _onLineTapped(Line line) {
    if (_selectedLine != null) {
      /*_updateSelectedLine(
        const LineOptions(
          lineWidth: 28.0,
        ),
      );*/
    }
    setState(() {
      _selectedLine = line;
    });

    /*_updateSelectedLine(
      LineOptions(
          // linecolor: ,
          ),
    );*/
  }

  /**
   * Calculates the distance between two coordinates
   */
  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  /**
   * If I click on the map it returns the coordinate of the nearest route, if it is more than 20 meters away it returns the coordinate of the point where we clicked
   */
  void _onMapClicked(Point<double> point, LatLng latLng) {
   /* double minDistance = 100000.0;
    GpsLocation selectedGpsLocation;
    this.tripData.coordinates.forEach((element) {
      double distance = calculateDistance(element.lat, element.long, latLng.latitude, latLng.longitude);
      if (distance < minDistance)
        minDistance = distance;
      selectedGpsLocation = element;
    });
    if (minDistance < 20.0) {
      tripPressCallback(selectedGpsLocation);
    }
    else {*/
      tripPressCallback(GpsLocation(latLng.latitude,latLng.longitude,0.0,0.0,0.0,0));
    /*}*/
  }

  void _updateSelectedLine(LineOptions changes) {
    controller.updateLine(_selectedLine, changes);
  }

  /**
   * Once loaded, the map draws the pre-specified route and indicates the Start-Stop event
   */
  void onStyleLoadedCallback() {
    addImageFromAsset();
    tripData.forEach((trip) {
      if (trip.coordinates.length > 1) {
        List<LatLng> geometry = [];
        trip.coordinates.sort((a, b) => a.time.compareTo(b.time));
        trip.coordinates.forEach((element) {
          geometry.add(LatLng(element.lat, element.long));
        });
        controller.addLine(
          LineOptions(
            geometry: geometry,
            lineColor: trip.color,
            lineWidth: 5.0,
            lineOpacity: 0.5,
          ),
        );

        _addEvent(trip.coordinates.first, "start");
        _addEvent(trip.coordinates.last, "stop");
      }
    });

    onStyleLoaded();
  }

  void _onEventTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedEvent(
        const SymbolOptions(iconSize: 1.0),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedEvent(
      SymbolOptions(
        iconSize: 1.4,
      ),
    );
  }

  Future<void>  _updateSelectedEvent(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }

  void _addEvent(GpsLocation event, String icon) {
    if (event != null) {
      controller.addSymbol(
          _getSymbolOptions(icon, event.time, "#ff0000",
              LatLng(event.lat,event.long)),
          {'eventId': event.time}
      );
      eventCount += 1;
      setState(() {
        _symbolCount += 1;
      });
    }
  }
  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount, String iconColor, LatLng coordinates){
    return SymbolOptions(
      geometry: coordinates,
      iconImage: iconImage,
      iconColor: iconColor,
    );
  }

  LatLngBounds boundsFromLatLngList() {
    assert(tripData.isNotEmpty);

    List<LatLng> list = new List<LatLng>();
    tripData.forEach((trip) {
      trip.coordinates.forEach((element) {
        list.add(LatLng(element.lat, element.long));
      });
    });
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: accessToken,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: onStyleLoadedCallback,
      onMapClick: _onMapClicked,
      cameraTargetBounds: CameraTargetBounds(boundsFromLatLngList()),
      initialCameraPosition: CameraPosition(
        target: LatLng(tripData.lastWhere((element) => element.coordinates.length > 1).coordinates.first.lat,tripData.lastWhere((element) => element.coordinates.length > 1).coordinates.first.long),
        zoom: 11.0,
      ),
    );
  }
}