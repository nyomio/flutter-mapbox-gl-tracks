// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

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
      Tracker(0,LatLng(47.08123+(Random().nextInt(9).toDouble()/10),19.04142+(Random().nextInt(9).toDouble()/10)),"#ff0000"),
      Tracker(1,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000"),
      Tracker(2,LatLng(48.10123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000"),
      Tracker(3,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000"),
      Tracker(4,LatLng(45.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000"),
      Tracker(5,LatLng(49.10123+(Random().nextInt(9).toDouble()/10),15.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000"),
      Tracker(6,LatLng(47.02123+(Random().nextInt(9).toDouble()/10),19.04142+(Random().nextInt(9).toDouble()/10)),"#0000ff"),
      Tracker(7,LatLng(47.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#0000ff"),
      Tracker(8,LatLng(48.10123+(Random().nextInt(9).toDouble()/10),19.15142+(Random().nextInt(9).toDouble()/10)),"#0000ff"),
      Tracker(10,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.25142+(Random().nextInt(9).toDouble()/10)),"#0000ff"),
      Tracker(11,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),16.05142+(Random().nextInt(9).toDouble()/10)),"#0000ff"),
      Tracker(12,LatLng(48.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#0000ff")
    ];
  }
  Route getRandomRoute() {
    return Route(0,
        [
          LatLng(47.08123+(Random().nextInt(9).toDouble()/10),19.04142+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.10123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(48.10123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(45.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(49.10123+(Random().nextInt(9).toDouble()/10),15.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.02123+(Random().nextInt(9).toDouble()/10),19.04142+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(48.10123+(Random().nextInt(9).toDouble()/10),19.15142+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.25142+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.10123+(Random().nextInt(9).toDouble()/10),16.05142+(Random().nextInt(9).toDouble()/10)),
          LatLng(48.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10))
        ],
        "#ff0000");
  }

  Event gerRandomEvent() {
      int randomNumber = Random().nextInt(2);
      return Event(
          eventCount + 1,
          randomNumber==0 ? "#ff0000" : "#00ff00",
          randomNumber==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),19.25142+(Random().nextInt(9).toDouble()/10)),
          0
      );
  }
  int eventCount = 0;
  int _lineCount = 0;
  Line _selectedLine;
  MapboxMapController controller;
  int _symbolCount = 0;
  Symbol _selectedSymbol;
  bool _iconAllowOverlap = false;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onTrackerTapped);
    controller.onLineTapped.add(_onLineTapped);

  }

  void _onStyleLoaded() {
      addImageFromAsset();
  }
  Future<void> addImageFromAsset() async{
       final ByteData bytes = await rootBundle.load("assets/symbols/start.png");
       final Uint8List list = bytes.buffer.asUint8List();
       await controller.addImage("start", list);
       final ByteData bytes2 = await rootBundle.load("assets/symbols/stop.png");
       final Uint8List list2 = bytes2.buffer.asUint8List();
       await controller.addImage("stop", list2);
       final ByteData bytes3 = await rootBundle.load("assets/symbols/map_poi.png");
       final Uint8List list3 = bytes3.buffer.asUint8List();
       await controller.addImage("poi", list3);
  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onTrackerTapped);
    controller?.onLineTapped?.remove(_onLineTapped);

    super.dispose();
  }
  void _onLineTapped(Line line) {
    if (_selectedLine != null) {
      _updateSelectedLine(
        const LineOptions(
          lineWidth: 28.0,
        ),
      );
    }
    setState(() {
      _selectedLine = line;
    });
    _updateSelectedLine(
      LineOptions(
        // linecolor: ,
      ),
    );
  }

  void _updateSelectedLine(LineOptions changes) {
    controller.updateLine(_selectedLine, changes);
  }
  void _addLine(Route route) {
    _removeLine();
    controller.addLine(
      LineOptions(
          geometry: route.coordinates,
          lineColor: route.color,
          lineWidth: 3.0,
          lineOpacity: 0.5,
          draggable: false
      ),
    );
    _selectedLine = controller.lines.first;
    setState(() {
      _lineCount += 1;
    });
  }

  void _removeLine() {
    if (controller.lines.isNotEmpty) {
      controller.removeLine(controller.lines.first);
      _lineCount -= 1;
      _selectedLine = null;
    }
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
  void _addEvent(Event event) {
    if (event != null) {
      controller.addSymbol(
          _getSymbolOptions(event.icon, event.id, event.color,
              event.coordinate),
          {'eventId': event.id}
      );
      eventCount += 1;
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
    return iconImage == 'customFont'
        ? SymbolOptions(
      geometry: geometry,
      iconImage: 'airport-15',
      fontNames: ['DIN Offc Pro Bold', 'Arial Unicode MS Regular'],
      textField: 'Airport',
      textSize: 12.5,
      textOffset: Offset(0, 0.8),
      textAnchor: 'top',
      textColor: '#000000',
      textHaloBlur: 1,
      textHaloColor: '#ffffff',
      textHaloWidth: 0.8,
    )
        : SymbolOptions(
      geometry: geometry,
      iconImage: iconImage,
      iconColor: iconColor,
    );
  }

  Future<void> _addAllTracker(List<Tracker> trackers) async {
    if (trackers != null && trackers.isNotEmpty) {
      trackers.forEach((tracker) {
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
            height: 300.0,
            child: MapboxMap(
              accessToken: MapsDemo.ACCESS_TOKEN,
              onMapCreated: _onMapCreated,
              onStyleLoadedCallback: _onStyleLoaded,
              initialCameraPosition: const CameraPosition(
                target: LatLng(47.506363, 19.049595),
                zoom: 11.0,
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
                          child: const Text('add event'),
                          onPressed: () => _addEvent(gerRandomEvent()),
                        ),
                        FlatButton(
                          child: const Text('add line'),
                          onPressed: () => _addLine(getRandomRoute()),
                        ),
                        FlatButton(
                          child: const Text('remove line'),
                          onPressed: () => _removeLine(),
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
  String iconImage = "poi";
  String color;
  LatLng coordinates;

  Tracker(int trackerId, LatLng coordinates, String color) {
    this.id = trackerId;
    this.coordinates = coordinates;
    this.color = color;
  }
}

class Route {
  int id;
  String color;
  List<LatLng> coordinates;

  Route(int lineId, List<LatLng> coordinates, String color) {
    this.id = lineId;
    this.coordinates = coordinates;
    this.color = color;
  }

}

class Event {
  int id;
  String color;
  String icon;
  LatLng coordinate;
  int trackerId;

  Event(int eventId, String eventColor, String eventIcon, LatLng eventCoordinate, int trackerId) {
    this.id = eventId;
    this.color = eventColor;
    this.trackerId = trackerId;
    this.coordinate = eventCoordinate;
    this.icon = eventIcon;
  }
}