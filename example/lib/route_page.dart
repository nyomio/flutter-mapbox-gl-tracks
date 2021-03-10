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
  List<Trip> trips() {
    List<Trip> trps = new List<Trip>();
    trps.add(Trip(0,"#ff0000",[GpsLocation(45.21,19.21,0.0,0.0,12.2,1231233123),GpsLocation(46.21,18.21,0.0,0.0,12.2,1531233123)],12));
    trps.add(Trip(1,"#00ff00",[GpsLocation(42.21,18.21,0.0,0.0,12.2,1231233123),GpsLocation(47.27,16.21,0.0,0.0,12.2,1531233123)],12));
    return trps;
  }
  Route getRandomRoute() {
    return Route(0,
        [
          LatLng(47.762529+(Random().nextInt(9).toDouble()/10),18.940043+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.811331+(Random().nextInt(9).toDouble()/10),18.989474+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.793036+(Random().nextInt(9).toDouble()/10),19.126671+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.685846+(Random().nextInt(9).toDouble()/10),19.135750+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.585239+(Random().nextInt(9).toDouble()/10),19.099433+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.489544+(Random().nextInt(9).toDouble()/10),19.070564+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.438249+(Random().nextInt(9).toDouble()/10),19.092536+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.373029+(Random().nextInt(9).toDouble()/10),19.100517+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.375888+(Random().nextInt(9).toDouble()/10),19.056196+(Random().nextInt(9).toDouble()/10))
        ],
        "#ff0000");
  }
  Route getRandomRoute2() {
    return Route(1,
        [
          LatLng(47.395893+(Random().nextInt(9).toDouble()/10),18.980921+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.361594+(Random().nextInt(9).toDouble()/10),18.895797+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.296268+(Random().nextInt(9).toDouble()/10),18.878209+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.223218+(Random().nextInt(9).toDouble()/10),18.883133+(Random().nextInt(9).toDouble()/10)),
          LatLng(47.227995+(Random().nextInt(9).toDouble()/10),18.672785+(Random().nextInt(9).toDouble()/10))
        ],
        "#fff000");
  }


  int _lineCount = 0;
  Line _selectedLine;
  MapboxMapController controller;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    controller.onLineTapped.add(_onLineTapped);

  }

  void _onStyleLoaded() {
    print("Ekkor töltött be a térkép");

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
  void _addLines(List<Route> routes) {
    _removeLines();
    routes.forEach((element) {
      controller.addLine(
        LineOptions(
            geometry: element.coordinates,
            lineColor: element.color,
            lineWidth: 4.0,
            lineOpacity: 0.5,
            draggable: false
        ),
      );
    });

    _selectedLine = controller.lines.first;
    setState(() {
      _lineCount = controller.lines.length;
    });
  }

  void _removeLines() {
    if (controller.lines.isNotEmpty) {
      controller.lines.forEach((element) {
          controller.removeLine(element);
      });
      _lineCount = 0;
      _selectedLine = null;
    }
  }

  List<Route> getRandomRoutes() {
    List<Route> routes = new List<Route>();
    routes.add(getRandomRoute());
    routes.add(getRandomRoute2());
      return routes;
  }
  Function callBackGps(GpsLocation gpsLocation){
    print(gpsLocation.toString());
  }

  @override
  Widget build(BuildContext context) {
    return  MapWithTrip(
                trips(),
                MapsDemo.ACCESS_TOKEN,
                startMarkerIconPath,
                stopMarkerIconPath,
                callBackGps,
                _onStyleLoaded
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
