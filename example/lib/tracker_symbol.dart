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
import 'package:mapbox_gl/mapbox_gl.dart';

import 'main.dart';
import 'page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:mapbox_gl/src/tracker_model.dart';
import 'package:mapbox_gl/src/tracker_map.dart';

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
  List<TrackerModel> getTrackerList() {
    return [
      TrackerModel(0,LatLng(47.49899088279303, 19.043703967040038),"#0000ff",startMarkerIconPath),
      TrackerModel(1,LatLng(47.499447697783566, 19.046033787747366),"#ff0000",stopMarkerIconPath),
      TrackerModel(2,LatLng(47.49853810834857, 19.041404693330232),"#00ff00",baseMarkerIconPath),
      TrackerModel(3,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),"#ffff00",pauseMarkerIconPath),
      TrackerModel(4,LatLng(45.10123+(Random().nextInt(9).toDouble()/10),18.05142+(Random().nextInt(9).toDouble()/10)),"#ffff00",startMarkerIconPath),
      TrackerModel(5,LatLng(49.10123+(Random().nextInt(9).toDouble()/10),15.05142+(Random().nextInt(9).toDouble()/10)),"#ff0000",stopMarkerIconPath),
      TrackerModel(6,LatLng(47.02123+(Random().nextInt(9).toDouble()/10),19.04142+(Random().nextInt(9).toDouble()/10)),"#0000ff",baseMarkerIconPath),
      TrackerModel(7,LatLng(47.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#00ffff",pauseMarkerIconPath),
      TrackerModel(8,LatLng(48.10123+(Random().nextInt(9).toDouble()/10),19.15142+(Random().nextInt(9).toDouble()/10)),"#0000ff",stopMarkerIconPath),
      TrackerModel(10,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),18.25142+(Random().nextInt(9).toDouble()/10)),"#00ffff",startMarkerIconPath),
      TrackerModel(11,LatLng(47.10123+(Random().nextInt(9).toDouble()/10),16.05142+(Random().nextInt(9).toDouble()/10)),"#00ff00",baseMarkerIconPath),
      TrackerModel(12,LatLng(48.15123+(Random().nextInt(9).toDouble()/10),19.05142+(Random().nextInt(9).toDouble()/10)),"#0000ff",stopMarkerIconPath)
    ];
  }
  List<TrackerModel> getTrackerList2() {
    return [
      TrackerModel(0,LatLng(47.49899088279303, 20.043703967040038),"#ff0000",startMarkerIconPath),
      TrackerModel(1,LatLng(47.499447697783566, 19.046033787747366),"#ff0000",stopMarkerIconPath)
    ];
  }
  void _onStyleLoaded() {
    print("Ekkor töltött be a térkép");
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onTrackerTapped(TrackerModel symbol) {
    print("SYMBOL -> " + symbol.id.toString() + " " + symbol.coordinates.toString());
  }
  TrackerMap trackerMap;
  @override
  Widget build(BuildContext context) {
    this.trackerMap = TrackerMap(
        getTrackerList(),
        MapsDemo.ACCESS_TOKEN,
        _onTrackerTapped,
        _onStyleLoaded
      );
    return trackerMap;
  }
}
