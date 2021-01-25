// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl_example/event_symbol.dart';
import 'package:mapbox_gl_example/full_map.dart';
import 'package:mapbox_gl_example/route_page.dart';
import 'package:mapbox_gl_example/tracker_symbol.dart';

import 'animate_camera.dart';
import 'full_map.dart';
import 'line.dart';
import 'map_ui.dart';
import 'move_camera.dart';
import 'page.dart';
import 'place_circle.dart';
import 'place_source.dart';
import 'place_symbol.dart';
import 'place_fill.dart';
import 'scrolling_map.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  TrackerSymbolPage(),
  EventSymbolPage(),
  RoutePage(),
  /*MoveCameraPage(),
  PlaceSymbolPage(),
  PlaceSourcePage(),
  LinePage(),
  PlaceCirclePage(),
  PlaceFillPage(),
  ScrollingMapPage(),*/
];

class MapsDemo extends StatelessWidget {

  // Add your Mapbox access token here
  static const String ACCESS_TOKEN = "pk.eyJ1IjoibmFneWlzdHZhbiIsImEiOiJja2lxczJ0dXgxenJjMzFxajVmamJxdGJiIn0.R1muCmqEhEJLAzGPMhcC2A";

  void _pushPage(BuildContext context, ExamplePage page) async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.GRANTED) {
        await location.requestPermission();
      }
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: ListView.builder(
        itemCount: _allPages.length,
        itemBuilder: (_, int index) => ListTile(
          leading: _allPages[index].leading,
          title: Text(_allPages[index].title),
          onTap: () => _pushPage(context, _allPages[index]),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: MapsDemo()));
}
