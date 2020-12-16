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

class RoutePage extends ExamplePage {
  RoutePage() : super(const Icon(Icons.share), 'Route page');

  @override
  Widget build(BuildContext context) {
    return const RoutePageBody();
  }
}

class RoutePageBody extends StatefulWidget {
  const RoutePageBody();

  @override
  State<StatefulWidget> createState() => RoutePageBodyState();
}

class RoutePageBodyState extends State<RoutePageBody> {
  RoutePageBodyState();

  static final LatLng center = const LatLng(47.506363, 19.049595);

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


  int _lineCount = 0;
  Line _selectedLine;
  MapboxMapController controller;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onLineTapped.add(_onLineTapped);

  }

  void _onStyleLoaded() {

  }
  @override
  void dispose() {
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
          lineWidth: 4.0,
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
                          child: const Text('add line'),
                          onPressed: () => _addLine(getRandomRoute()),
                        ),
                        FlatButton(
                          child: const Text('remove line'),
                          onPressed: () => _removeLine(),
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
