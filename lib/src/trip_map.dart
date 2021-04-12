
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mapbox_gl/src/Constants.dart';
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

  Future<void> addStartImageAsset(String color, GpsLocation event) async {
    final String assetName = widget.startIconPath;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(Constants.fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90, 90);
    final ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List list = bytes.buffer.asUint8List();
    String iconName = "start_"+color.replaceAll("#", "_");
    await controller.addImage(iconName, list).whenComplete(() => _addEvent(event, iconName));
  }
  Future<void> addEndImageAsset(String color, GpsLocation event) async {
    final String assetName = widget.endIconPath;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(Constants.fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90, 90);
    final ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List list = bytes.buffer.asUint8List();
    String iconName = "stop_"+color.replaceAll("#", "_");
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
    if(widget.tripData != null && widget.tripData.isNotEmpty) {
      setUpTrips();
      List<LatLng> list = new List<LatLng>();
      widget.tripData.map((e) => e.coordinates).forEach((element) {
        element.forEach((gpsLocation) {
          list.add(LatLng(gpsLocation.lat, gpsLocation.long));
        });
      });
      controller.moveCamera(
          CameraUpdate.newLatLngBounds(Constants.boundsFromLatLngList(list)));
    }
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
            lineColor: trip.pathColor,
            lineWidth: 5.0,
            lineOpacity: 0.5,
          ),
        );

        addStartImageAsset(trip.startColor, trip.coordinates.first);
        addEndImageAsset(trip.endColor, trip.coordinates.last);
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
          Constants.getSymbolOptions(icon, LatLng(event.lat,event.long), event.time.toString()), {'eventId': event.time}
      );
      print("addEvent " + icon);
      eventCount += 1;
      setState(() {
        _symbolCount += 1;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: widget.accessToken,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: onStyleLoadedCallback,
      onMapClick: _onMapClicked,
      styleString: Constants.MAP_TILE_JSON,
      initialCameraPosition: CameraPosition(
        target: LatLng(47,19),
        zoom: 11.0,
      ),
    );
  }
}