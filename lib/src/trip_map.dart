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
  final List<Trip> tripData;
  final String accessToken;
  final String startIconPath;
  final String endIconPath;
  final Function(GpsLocation) tripPressCallback;
  final Function() onStyleLoaded;

  MapWithTrip(this.tripData, this.accessToken, this.startIconPath, this.endIconPath, this.tripPressCallback, this.onStyleLoaded);

  @override
  State<StatefulWidget> createState() => MapWithTripState();
}

class MapWithTripState extends State<MapWithTrip> {
  Symbol _selectedSymbol;
  MapboxMapController controller;
  Line _selectedLine;

  bool _startImageAdded = false;

  Future<void> addStartImageAsset(String color, GpsLocation location) async {
    String iconName = "start_" + color.replaceAll("#", "_");
    if (!_startImageAdded) {
      String assetName = widget.startIconPath;
      String svgString = await rootBundle.loadString(assetName);
      DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
      ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(Constants.fromHex(color), BlendMode.srcIn));
      ui.Image _image = await picture.toImage(90, 90);
      ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List list = bytes.buffer.asUint8List();
      await controller.addImage(iconName, list);
      _startImageAdded = true;
    }
    _addLocation(location, iconName);
  }

  bool _stopImageAdded = false;

  Future<void> addEndImageAsset(String color, GpsLocation location) async {
    String iconName = "stop_" + color.replaceAll("#", "_");
    if (!_stopImageAdded) {
      String assetName = widget.endIconPath;
      String svgString = await rootBundle.loadString(assetName);
      DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
      ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(Constants.fromHex(color), BlendMode.srcIn));
      ui.Image _image = await picture.toImage(90, 90);
      ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List list = bytes.buffer.asUint8List();
      await controller.addImage(iconName, list);
      _stopImageAdded = true;
    }
    _addLocation(location, iconName);
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

  /// If I click on the map it returns the coordinate of the nearest route, if it is more than 20 meters away it returns the coordinate of the point where we clicked
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
    widget.tripPressCallback(GpsLocation(latLng.latitude, latLng.longitude, 0.0, 0.0, 0.0, 0));
    /*}*/
  }

  void _updateSelectedLine(LineOptions changes) {
    controller.updateLine(_selectedLine, changes);
  }

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    //controller.onLineTapped.add(_onLineTapped);
  }

  ///Once loaded, the map draws the pre-specified route and indicates the Start-Stop event
  Future<void> onStyleLoadedCallback() async {
    List<LatLng> list = [];
    if (widget.tripData != null) {
      for (Trip trip in widget.tripData) {
        for (GpsLocation loc in trip.coordinates) {
          list.add(LatLng(loc.lat, loc.long));
        }
      }
      await setUpTrips();
    }
    await controller.moveCamera(CameraUpdate.newLatLngBounds(Constants.boundsFromLatLngList(list)));
    widget.onStyleLoaded();
  }

  Future<void> setUpTrips() async {
    for (Trip trip in widget.tripData) {
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
    }
  }

  void _onEventTapped(Symbol symbol) {
    setState(() {
      _selectedSymbol = symbol;
    });
  }

  Future<void> _updateSelectedEvent(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }

  Future<void> _addLocation(GpsLocation location, String icon) async {
    if (location != null) {
      await controller.addSymbol(Constants.getSymbolOptions(icon, LatLng(location.lat, location.long), location.time.toString()), {'eventId': location.time});
      //print("addEvent " + icon);
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
        target: LatLng(47, 19),
        zoom: 11.0,
      ),
    );
  }
}
