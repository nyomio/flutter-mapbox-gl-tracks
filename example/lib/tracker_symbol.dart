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
  List<LatLng> trackerList = [LatLng(47.08123,19.04142),LatLng(47.10123,19.05142),LatLng(48.10123,19.05142), LatLng(47.10123,18.05142), LatLng(45.10123,18.05142), LatLng(49.10123,15.05142),
                              LatLng(47.02123,19.04142),LatLng(47.15123,19.05142),LatLng(48.10123,19.15142), LatLng(47.10123,18.25142), LatLng(47.10123,16.05142), LatLng(48.15123,19.05142)];
  MapboxMapController controller;
  int _symbolCount = 0;
  Symbol _selectedSymbol;
  bool _iconAllowOverlap = false;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onSymbolTapped.add(_onTrackerTapped);
  }

  void _onStyleLoaded() {
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

  void _addTracker(String iconImage, String iconColor) {
    List<int> availableNumbers = Iterable<int>.generate(12).toList();
    controller.symbols.forEach(
            (s) => availableNumbers.removeWhere((i) => i == s.data['count'])
    );
    if (availableNumbers.isNotEmpty) {
      controller.addSymbol(
          _getSymbolOptions(iconImage, availableNumbers.first, iconColor),
          {'count': availableNumbers.first}
      );
      setState(() {
        _symbolCount += 1;
      });
    }
  }

  SymbolOptions _getSymbolOptions(String iconImage, int symbolCount, String iconColor){
    LatLng geometry = LatLng(
      trackerList[symbolCount].latitude,
      trackerList[symbolCount].longitude,
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

  Future<void> _addAllTracker(String iconImage, String iconColor) async {
    List<int> symbolsToAddNumbers = Iterable<int>.generate(12).toList();
    controller.symbols.forEach(
            (s) => symbolsToAddNumbers.removeWhere((i) => i == s.data['count'])
    );

    if (symbolsToAddNumbers.isNotEmpty) {
      final List<SymbolOptions> symbolOptionsList = symbolsToAddNumbers.map(
              (i) => _getSymbolOptions(iconImage, i, iconColor)
      ).toList();
      controller.addSymbols(
          symbolOptionsList,
          symbolsToAddNumbers.map((i) => {'count': i}).toList()
      );

      setState(() {
        _symbolCount += symbolOptionsList.length;
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
                          onPressed: () => _addTracker("airport-15", "#ff0000"),
                        ),
                        FlatButton(
                          child: const Text('add all tracker'),
                          onPressed: () =>
                          (controller.symbols.isNotEmpty) ? null : _addAllTracker("airport-15", "#ff0000"),
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
                     /*   FlatButton(
                          child: const Text('hide blue trackers'),
                          onPressed: () => (_selectedSymbol == null)
                              ? null
                              : _hideAllTrackerIf(),
                        ),*/
                   /*     FlatButton(
                          child: const Text('change tracker color'),
                          onPressed: (_selectedSymbol == null)
                              ? null
                              : _changeIconAnchor,
                        ),*/
                        FlatButton(
                          child: const Text('show all tracker'),
                          onPressed: () => _showAllTracker(),
                        ),
                        FlatButton(
                          child: const Text('change position of first tracker'),
                          onPressed: () => _changeTrackerPosition(controller.symbols.first, LatLng(47.506914+(Random().nextInt(9).toDouble()/10),19.048292+(Random().nextInt(9).toDouble()/10))),
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
