
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
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
  State<StatefulWidget> createState() => MapWithTripState();
}

class MapWithTripState extends State<MapWithTrip> {

  int _symbolCount = 0;
  int eventCount = 0;
  Symbol _selectedSymbol;
  MapboxMapController controller;
  Line _selectedLine;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    //controller.onLineTapped.add(_onLineTapped);
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future<void> addStartImageAsset(String color, GpsLocation event) async {
    final String assetName = widget.startIconPath;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90, 90);
    final ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List list = bytes.buffer.asUint8List();
    String iconName = "start"+color.replaceAll("#", "_");
    await controller.addImage(iconName, list).whenComplete(() => _addEvent(event, iconName));
  }
  Future<void> addEndImageAsset(String color, GpsLocation event) async {
    final String assetName = widget.endIconPath;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90, 90);
    final ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List list = bytes.buffer.asUint8List();
    String iconName = "stop"+color.replaceAll("#", "_");
    await controller.addImage(iconName, list).whenComplete(() => _addEvent(event, iconName));
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
    widget.tripPressCallback(GpsLocation(latLng.latitude,latLng.longitude,0.0,0.0,0.0,0));
    /*}*/
  }

  void _updateSelectedLine(LineOptions changes) {
    controller.updateLine(_selectedLine, changes);
  }

  /**
   * Once loaded, the map draws the pre-specified route and indicates the Start-Stop event
   */
  void onStyleLoadedCallback() {
    setUpTrips();
    controller.moveCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList()));
    widget.onStyleLoaded();
  }

  void setUpTrips(){
    widget.tripData.forEach((trip) {
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

        addStartImageAsset(trip.color, trip.coordinates.first);
        addEndImageAsset(trip.color, trip.coordinates.last);
      }
    });
  }

  void _onEventTapped(Symbol symbol) {
    setState(() {
      _selectedSymbol = symbol;
    });
  }

  Future<void>  _updateSelectedEvent(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }

  void _addEvent(GpsLocation event, String icon) {
    if (event != null) {
      controller.addSymbol(
          _getSymbolOptions(icon, event.time, "#ff0000",
              LatLng(event.lat,event.long), event.time.toString()),
          {'eventId': event.time}
      );
      print("addEvent " + icon);
      eventCount += 1;
      setState(() {
        _symbolCount += 1;
      });
    }
  }
  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount, String iconColor, LatLng coordinates, String name){
    return SymbolOptions(
      geometry: coordinates,
      iconImage: iconImage,
      iconColor: iconColor,
      textField: "",
      textSize: 12.0,
      iconOffset: Offset(0.0,-10.0),
      textAnchor: "top",
      textColor: "#00000000",
      iconSize: _getSymbolIconSize()
    );
  }
  double _getSymbolIconSize() {
    if (Platform.isAndroid) {
      return 1.0;
    } else if (Platform.isIOS) {
      return 0.5;
    }
  }
  LatLngBounds boundsFromLatLngList() {
    assert(widget.tripData.isNotEmpty);

    List<LatLng> list = new List<LatLng>();
    widget.tripData.forEach((trip) {
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


    //if no data provided, hungary bounds default
    if (x0 == null || y0 == null || x1 == null || y1 == null) {
      x0 = 46;
      y0 = 16;
      x1 = 47;
      y1 = 22;
    }


    // OPTIONAL - Add some extra "padding" for better map display
    double padding = 1;
    double south = x0 - padding;
    double west = y0 - padding;
    double north = x1 + padding;
    double east = y1 + padding;

    LatLng northeast = LatLng(north, east);
    LatLng southwest = LatLng(south, west);

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: widget.accessToken,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: onStyleLoadedCallback,
      onMapClick: _onMapClicked,
      initialCameraPosition: CameraPosition(
        target: LatLng(47,19),
        zoom: 11.0,
      ),
    );
  }
}