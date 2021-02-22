// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';
//roadblock-11 stop sign
//marker-15 normal poi

class TrackerSymbolPage extends ExamplePage {
  TrackerSymbolPage() : super(const Icon(Icons.place), 'Tracker symbol');

  @override
  Widget build(BuildContext context) {
    return const TrackerSymbolBody();
  }
}

class TrackerSymbolBody extends StatefulWidget {
  const TrackerSymbolBody();

  @override
  State<StatefulWidget> createState() => TrackerSymbolBodyState();
}

class TrackerSymbolBodyState extends State<TrackerSymbolBody> {
  TrackerSymbolBodyState();

  static final LatLng center = const LatLng(47.506363, 19.049595);
  List<Tracker> getTrackerList() {
    return [
      Tracker(0,LatLng(47.49899088279303, 19.043703967040038),"#ff0000","marker"),
      Tracker(1,LatLng(47.499447697783566, 19.046033787747366),"#ff0000","marker"),
      Tracker(2,LatLng(47.49853810834857, 19.041404693330232),"#00ff00","marker"),
      Tracker(3,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),"#ffff00","marker"),
      Tracker(4,LatLng(45.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),"#ffff00","marker"),
      Tracker(5,LatLng(49.10123+(Random().nextInt(9).toDouble()/10),15.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000","marker"),
      Tracker(6,LatLng(47.02123+(Random().nextInt(9).toDouble()/10),19.04142+(Random().nextInt(9).toDouble()/10)),"#0000ff","marker"),
      Tracker(7,LatLng(47.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#00ffff","marker"),
      Tracker(8,LatLng(48.10123+(Random().nextInt(9).toDouble()/10),19.15142+(Random().nextInt(9).toDouble()/10)),"#0000ff","marker"),
      Tracker(10,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.25142+(Random().nextInt(9).toDouble()/10)),"#00ffff","marker"),
      Tracker(11,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),16.05142+(Random().nextInt(9).toDouble()/10)),"#00ff00","marker"),
      Tracker(12,LatLng(48.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#0000ff","marker")
    ];
  }

  MapboxMapController controller;
  int _symbolCount = 0;
  Symbol _selectedSymbol;
  bool _iconAllowOverlap = false;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onTrackerTapped);

  }

  void _onStyleLoaded() {
    addImageFromAsset();
    print("Ekkor töltött be a térkép");
  }
  Future<void> addImageFromAsset() async{
/*    _makeIconFromSVGAsset("assets/symbols/start.svg","start");
    _makeIconFromSVGAsset("assets/symbols/marker.svg","marker");
    _makeIconFromSVGAsset("assets/symbols/stop.svg","stop");*/
    /*   final ByteData bytes = await rootBundle.load("assets/symbols/start.png");
       final Uint8List list = bytes.buffer.asUint8List();
       await controller.addImage("start", list);
       final ByteData bytes2 = await rootBundle.load("assets/symbols/stop.png");
       final Uint8List list2 = bytes2.buffer.asUint8List();
       await controller.addImage("stop", list2);
       final ByteData bytes3 = await rootBundle.load("assets/symbols/marker.png");
       final Uint8List list3 = bytes3.buffer.asUint8List();
       await controller.addImage("marker", list3);*/
  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onTrackerTapped);
    super.dispose();
  }


  void _onTrackerTapped(Symbol symbol) {
    if (_selectedSymbol != null) {
      _updateSelectedTracker(
        const SymbolOptions(iconSize: 1.0),
      );
    }
    setState(() {
      _selectedSymbol = symbol;
    });
    _updateSelectedTracker(
      SymbolOptions(
        iconSize: 1.4,
      ),
    );
  }
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }


  Future<void> _makeIconFromSVGAsset(String path, String name, String color) async{
    final String assetName = path;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90 , 90);
    final ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List list = bytes.buffer.asUint8List();
    await controller.addImage(name, list);
  }

  void _addTracker(Tracker tracker) {
    if (tracker != null) {
      controller.addSymbol(
          _getSymbolOptions(tracker.iconImage, tracker.id, tracker.color,
              tracker.coordinates),
          {'trackerId': tracker.id}
      );
      setState(() {
        _symbolCount += 1;
      });
    }
  }

  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount, String iconColor, LatLng coordinates){
    LatLng geometry = LatLng(
      coordinates.latitude,
      coordinates.longitude,
    );
    if (Platform.isAndroid) {
      return SymbolOptions(
          geometry: geometry,
          iconImage: iconImage,
          iconColor: iconColor,
          iconOffset: Offset(0,0),
          iconOpacity: 1.0,
          iconAnchor: "bottom",
          iconSize: 1.0
      );
    } else if (Platform.isIOS) {
      return SymbolOptions(
          geometry: geometry,
          iconImage: iconImage,
          iconColor: iconColor,
          iconOffset: Offset(0,0),
          iconOpacity: 1.0,
          iconAnchor: "bottom",
          iconSize: 0.5
      );
    }

  }

  Future<void> _addAllTracker(List<Tracker> trackers) async {
    if (trackers != null && trackers.isNotEmpty) {
      trackers.forEach((tracker) {
        String trackerColor = tracker.color;
        String trackerIconName = tracker.iconImage+tracker.color.replaceAll("#", "");
        switch (tracker.iconImage){
          case "start": {
            _makeIconFromSVGAsset("assets/symbols/start.svg",trackerIconName,trackerColor);
            break;
          }
          case "stop": {
            _makeIconFromSVGAsset("assets/symbols/stop.svg",trackerIconName,trackerColor);
            break;
          }
          case "marker": {

            _makeIconFromSVGAsset("assets/symbols/marker-15.svg",trackerIconName,trackerColor);
            break;
          }
          default: {

          }
        }
        tracker.iconImage = trackerIconName;

        controller.addSymbol(
            _getSymbolOptions(tracker.iconImage, tracker.id, tracker.color, tracker.coordinates),
            {'trackerId': tracker.id}
        );
      });

      setState(() {
        _symbolCount += trackers.length;
      });
    }
  }
  Future<void> _removeTracker(Symbol symbol) {
    _selectedSymbol = symbol;
    controller.removeSymbol(_selectedSymbol);
    setState(() {
      _selectedSymbol = null;
      _symbolCount -= 1;
    });
  }
  Future<void>  _removeAllTracker() {
    controller.removeSymbols(controller.symbols);
    setState(() {
      _selectedSymbol = null;
      _symbolCount = 0;
    });
  }
  Future<void> _updateAllTrackerPosition(List<Tracker> trackers) {
    trackers.forEach((tracker) {
      Symbol symbol = controller.symbols.firstWhere((element) =>
      element.data["trackerId"] == tracker.id);
      if (symbol != null) {
        _selectedSymbol = symbol;
        _updateSelectedTracker(
          SymbolOptions(
            geometry: LatLng(
              tracker.coordinates.latitude,
              tracker.coordinates.longitude,
            ),
          ),
        );
      }
    });
  }
  Future<void>  _changeTrackerPosition(Symbol symbol, LatLng newCoordinate) {
    _selectedSymbol = symbol;
    _updateSelectedTracker(
      SymbolOptions(
        geometry: LatLng(
          newCoordinate.latitude,
          newCoordinate.longitude,
        ),
      ),
    );
  }
  Future<void>  _updateSelectedTracker(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }
  Future<void> _hideAllTrackerIf(bool condition) async {
    controller.symbols.forEach((element) {
      if (condition) {
        _updateSelectedTracker(
          SymbolOptions(iconOpacity: 0.0),
        );
      }
    });
  }

  Future<void> _hideAllTracker() async {
    controller.symbols.forEach((element) {
      _selectedSymbol = element;
      _updateSelectedTracker(
        SymbolOptions(iconOpacity: 0.0),
      );
    });
  }

  Future<void> _showAllTrackerIf(bool condition) async {
    controller.symbols.forEach((element) {
      if (condition) {
        _updateSelectedTracker(
          SymbolOptions(iconOpacity: 1.0),
        );
      }
    });
  }

  Future<void> _showAllTracker() async {
    controller.symbols.forEach((element) {
      _selectedSymbol = element;
      _updateSelectedTracker(
        SymbolOptions(iconOpacity: 1.0),
      );
    });
  }

  void _getLatLng() async {
    LatLng latLng = await controller.getSymbolLatLng(_selectedSymbol);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(latLng.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 300.0,
            height: 500.0,
            child: MapboxMap(
              accessToken: MapsDemo.ACCESS_TOKEN,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoaded,
              minMaxZoomPreference: MinMaxZoomPreference(5,16),
              initialCameraPosition: const CameraPosition(
                target: LatLng(47.506363, 19.049595),
                zoom: 8.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('add tracker'),
                          onPressed: () => _addTracker(getTrackerList().first),
                        ),
                        FlatButton(
                          child: const Text('add all tracker'),
                          onPressed: () =>
                          (controller.symbols.isNotEmpty) ? null : _addAllTracker(getTrackerList()),
                        ),
                        FlatButton(
                          child: const Text('remove tracker'),
                          onPressed: () => (controller.symbols.isEmpty) ? null : _removeTracker(controller.symbols.first),
                        ),
                        FlatButton(
                          child: const Text('remove all tracker'),
                          onPressed: () => (controller.symbols.isEmpty) ? null : _removeAllTracker(),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('hide all tracker'),
                          onPressed: () =>
                              _hideAllTracker(),
                        ),
                        FlatButton(
                          child: const Text('show all tracker'),
                          onPressed: () => _showAllTracker(),
                        ),
                        FlatButton(
                          child: const Text('change position of first tracker'),
                          onPressed: () => _changeTrackerPosition(controller.symbols.first, LatLng(47.506914+(Random().nextInt(9).toDouble()/10),19.048292+(Random().nextInt(9).toDouble()/10))),
                        ),
                        FlatButton(
                          child: const Text('change position of all tracker'),
                          onPressed: () => _updateAllTrackerPosition(getTrackerList()),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Tracker {
  int id;
  String iconImage;
  String color;
  LatLng coordinates;

  Tracker(int trackerId, LatLng coordinates, String color, String image) {
    this.id = trackerId;
    this.coordinates = coordinates;
    this.color = color;
    this.iconImage = image;
  }
}
