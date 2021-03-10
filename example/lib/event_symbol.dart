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

class EventSymbolPage extends ExamplePage {
  EventSymbolPage() : super(const Icon(Icons.event), 'Event symbol');

  @override
  Widget build(BuildContext context) {
    return const EventSymbolPageBody();
  }
}

class EventSymbolPageBody extends StatefulWidget {
  const EventSymbolPageBody();

  @override
  State<StatefulWidget> createState() => EventSymbolPageBodyState();
}

class EventSymbolPageBodyState extends State<EventSymbolPageBody> {
  EventSymbolPageBodyState();

  static final LatLng center = const LatLng(47.506363, 19.049595);

  Event getRandomEvent() {
    int randomNumber = Random().nextInt(2);
    return Event(
        eventCount + 1,
        randomNumber==0 ? "#ff0000" : "#00ff00",
        randomNumber==0 ? "start" : "stop",
        LatLng(47.40123+(Random().nextInt(9).toDouble()/10),19.25142+(Random().nextInt(9).toDouble()/10)),
        0
    );
  }
  List<Event> getRandomEvents() {
    eventCount = 9;
    return [
      Event(
        1,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
        LatLng(46.40123+(Random().nextInt(9).toDouble()/10),18.25142+(Random().nextInt(9).toDouble()/10)),
        0
    ),
      Event(
          2,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),19.75142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          3,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),18.55142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          4,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),20.25142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          5,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),16.25142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          6,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),17.25142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          7,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(47.40123+(Random().nextInt(9).toDouble()/10),18.25142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          8,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(48.40123+(Random().nextInt(9).toDouble()/10),19.25142+(Random().nextInt(9).toDouble()/10)),
          0
      ),
      Event(
          9,
          Random().nextInt(2)==0 ? "#ff0000" : "#00ff00",
          Random().nextInt(2)==0 ? "start" : "stop",
          LatLng(46.40123+(Random().nextInt(9).toDouble()/10),19.25142+(Random().nextInt(9).toDouble()/10)),
          0
      )];

  }
  int eventCount = 0;
  MapboxMapController controller;
  int _symbolCount = 0;
  Symbol _selectedSymbol;
  bool _iconAllowOverlap = false;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onEventTapped);

  }

  void _onStyleLoaded() {
    addImageFromAsset();
    print("Ekkor töltött be a térkép");

  }
  Future<void> addImageFromAsset() async{
    final ByteData bytes = await rootBundle.load(startMarkerIconPath);
    final Uint8List list = bytes.buffer.asUint8List();
    await controller.addImage("start", list);
    final ByteData bytes2 = await rootBundle.load(stopMarkerIconPath);
    final Uint8List list2 = bytes2.buffer.asUint8List();
    await controller.addImage("stop", list2);

  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onEventTapped);
    super.dispose();
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

  Future<void> _addAllEvent(List<Event> events) async {
    if (events != null && events.isNotEmpty) {
      _removeAllEvent();
      events.forEach((event) {
        controller.addSymbol(
            _getSymbolOptions(event.icon, event.id, event.color, event.coordinate),
            {'eventId': event.id}
        );
      });

      setState(() {
        _symbolCount += events.length;
      });
    }
  }
  Future<void> _removeEvent(Symbol symbol) {
    _selectedSymbol = symbol;
    controller.removeSymbol(_selectedSymbol);
    setState(() {
      _selectedSymbol = null;
      _symbolCount -= 1;
    });
  }
  Future<void>  _removeAllEvent() {
    controller.removeSymbols(controller.symbols);
    setState(() {
      _selectedSymbol = null;
      _symbolCount = 0;
    });
  }
  Future<void>  _updateSelectedEvent(SymbolOptions changes) {
    controller.updateSymbol(_selectedSymbol, changes);
  }
  Future<void> _hideAllEventIf(bool condition) async {
    controller.symbols.forEach((element) {
      if (condition) {
        _updateSelectedEvent(
          SymbolOptions(iconOpacity: 0.0),
        );
      }
    });
  }

  Future<void> _hideAllEvent() async {
    controller.symbols.forEach((element) {
      _selectedSymbol = element;
      _updateSelectedEvent(
        SymbolOptions(iconOpacity: 0.0),
      );
    });
  }

  Future<void> _showAllEventIf(bool condition) async {
    controller.symbols.forEach((element) {
      if (condition) {
        _updateSelectedEvent(
          SymbolOptions(iconOpacity: 1.0),
        );
      }
    });
  }

  Future<void> _showAllEvent() async {
    controller.symbols.forEach((element) {
      _selectedSymbol = element;
      _updateSelectedEvent(
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
                          child: const Text('add event'),
                          onPressed: () => _addEvent(getRandomEvent()),
                        ),
                        FlatButton(
                          child: const Text('add all event'),
                          onPressed: () => _addAllEvent(getRandomEvents()),
                        ),
                        FlatButton(
                          child: const Text('remove event'),
                          onPressed: () => (controller.symbols.isEmpty) ? null : _removeEvent(controller.symbols.first),
                        ),
                        FlatButton(
                          child: const Text('remove all event'),
                          onPressed: () => (controller.symbols.isEmpty) ? null : _removeAllEvent(),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('hide all event'),
                          onPressed: () =>
                              _hideAllEvent(),
                        ),
                        FlatButton(
                          child: const Text('show all event'),
                          onPressed: () => _showAllEvent(),
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