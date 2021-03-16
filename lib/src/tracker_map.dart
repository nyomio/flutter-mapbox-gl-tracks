import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io' show Platform;

import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'tracker_model.dart';

// ignore: must_be_immutable
class TrackerMap extends StatefulWidget {
  List<TrackerModel> trackers;
  final String accessToken;
  final Function(TrackerModel) trackerPressCallback;
  final Function() onStyleLoaded;

  TrackerMap(this.trackers, this.accessToken, this.trackerPressCallback, this.onStyleLoaded, {GlobalKey<TrackerMapState> trackerMapKey})
      : super(key: trackerMapKey);
  TrackerMapState mapState = new TrackerMapState();

  @override
  State<StatefulWidget> createState() => mapState;

  void addTracker(TrackerModel newTracker) async {
    await mapState.addTracker(newTracker);
  }

  void addTrackers(List<TrackerModel> trackers) async {
    await mapState._addImages(trackers);
  }

  void replaceTrackers(List<TrackerModel> newTrackers) async {
    await mapState.replaceTrackers(newTrackers);
  }

  void hideTrackersById(List<int> trackerIds) async {
    await mapState.hideTrackersById(trackerIds);
  }

  void showTrackersById(List<int> trackerIds) async {
    await mapState.showTrackersById(trackerIds);
  }

  removeTrackers() async {
    await mapState.removeTrackers();
  }

  removeTracker(int trackerId) async {
    await mapState.removeTracker(trackerId);
  }

  updateTrackersCoordinates(List<TrackerModel> trackers) async {
    await mapState.updateAllTrackerPosition(trackers);
  }

  updateTrackerCoordinates(TrackerModel trackerModel) async {
    await mapState._updateTrackerPosition(trackerModel.id, trackerModel.coordinates);
  }

  updateTracker(TrackerModel trackerModel) async {
    await mapState.updateTracker(trackerModel);
  }
}

class TrackerMapState extends State<TrackerMap> {
  int _symbolCount = 0;
  int _imageCount = 0;

  Symbol _selectedSymbol;
  MapboxMapController controller;
  Line _selectedLine;

  List<TrackerModel> widgetTrackers;

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;
    this.controller?.onSymbolTapped?.add(_onTrackerTapped);
  }

  @override
  void dispose() {
    controller?.onSymbolTapped?.remove(_onTrackerTapped);
    super.dispose();
  }

  /**
   * Calculates the distance between two coordinates
   */
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  /**
   * If I click on the map it returns the coordinate of the nearest route, if it is more than 20 meters away it returns the coordinate of the point where we clicked
   */
  void _onMapClicked(Point<double> point, LatLng latLng) {}

  /**
   * Once loaded, the map draws the pre-specified route and indicates the Start-Stop event
   */
  void onStyleLoadedCallback() {
    if (widget.trackers != null && widget.trackers.isNotEmpty) {
      _addImages(widget.trackers);
    }
    // addAllTracker(widget.trackers)
    widget.onStyleLoaded();
  }

  void _onTrackerTapped(Symbol symbol) {
    setState(() {
      _selectedSymbol = symbol;
    });
    Map<dynamic, dynamic> data = symbol.data;
    var trackerId = data["trackerId"];
    widget.trackerPressCallback(TrackerModel(trackerId, symbol.options.geometry, symbol.options.iconColor, symbol.options.iconImage));
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Future _makeIconFromSVGAsset(String path, String name, String color) async {
    final String assetName = path;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90, 90);
    final ByteData bytes = await _image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List list = bytes.buffer.asUint8List();
    await controller.addImage(name, list);
  }

  Future _updateSelectedTracker(SymbolOptions changes) async {
    await controller.updateSymbol(_selectedSymbol, changes);
  }

  Future addTracker(TrackerModel tracker) async {
    if (widgetTrackers == null) widgetTrackers = new List<TrackerModel>();
    widgetTrackers.add(tracker);
    String trackerColor = tracker.color;
    String trackerIconName = "marker" + tracker.id.toString() + tracker.color.replaceAll("#", "");
    await _makeIconFromSVGAsset(tracker.iconImage, trackerIconName, trackerColor);
    await _imageAdded(tracker);
  }

  SymbolOptions _getSymbolOptions(String iconImage, LatLng coordinates, String name) {
    LatLng geometry = LatLng(
      coordinates.latitude,
      coordinates.longitude,
    );

    return SymbolOptions(
        geometry: geometry,
        iconImage: iconImage,
        iconOffset: Offset(0, 0),
        iconOpacity: 1.0,
        iconAnchor: "bottom",
        iconSize: _getSymbolIconSize(),
        textField: "",
        textSize: 12.0,
        textAnchor: "top",
        textColor: "#00000000");
  }

  double _getSymbolIconSize() {
    if (Platform.isAndroid) {
      return 1.0;
    } else if (Platform.isIOS) {
      return 0.5;
    }
  }

  Future _imageAdded(TrackerModel tracker) async {
    _imageCount = 0;
    print("_imageAdded " + tracker.id.toString());
    String trackerColor = tracker.color;
    String trackerIconName = "marker" + tracker.id.toString() + tracker.color.replaceAll("#", "");
    await controller.addSymbol(_getSymbolOptions(trackerIconName, tracker.coordinates, tracker.id.toString()), {'trackerId': tracker.id});
    setState(() {
      _symbolCount += 1;
    });
  }

  Future _imagesAdded(List<TrackerModel> trackers) async {
    _imageCount++;
    if (_imageCount == trackers.length) {
      _imageCount = 0;
      await addTrackers(trackers);
    }
  }

  Future _addImages(List<TrackerModel> trackers) async {
    if (widgetTrackers == null) widgetTrackers = new List<TrackerModel>();
    widgetTrackers.addAll(trackers);
    _imageCount = 0;
    for (TrackerModel tracker in trackers) {
      String trackerColor = tracker.color;
      String trackerIconName = "marker" + tracker.id.toString() + tracker.color.replaceAll("#", "");
      await _makeIconFromSVGAsset(tracker.iconImage, trackerIconName, trackerColor);
      await _imagesAdded(trackers);
    }
  }

  Future replaceTrackers(List<TrackerModel> trackers) async {
    _imageCount = 0;
    _symbolCount = 0;
    await controller.removeSymbols(controller.symbols);
    await _addImages(trackers);
  }

  Future addTrackers(List<TrackerModel> trackers) async {
    if (trackers != null && trackers.isNotEmpty) {
      trackers.forEach((tracker) {
        String trackerIconName = "marker" + tracker.id.toString() + tracker.color.replaceAll("#", "");
        tracker.iconImage = trackerIconName;
        controller.addSymbol(_getSymbolOptions(tracker.iconImage, tracker.coordinates, tracker.id.toString()), {'trackerId': tracker.id});
      });

      setState(() {
        _symbolCount += trackers.length;
      });
      await controller.moveCamera(CameraUpdate.newLatLngBounds(boundsFromLatLngList()));
    }
  }

  Future removeTracker(int trackerId) async {
    if (trackerId != null) {
      _selectedSymbol = controller.symbols.firstWhere((element) => element.data["trackerId"] == trackerId);
      await controller.removeSymbol(_selectedSymbol);
      setState(() {
        _selectedSymbol = null;
        _symbolCount -= 1;
      });
    }
  }

  Future removeTrackers() async {
    await controller.removeSymbols(controller.symbols);
    setState(() {
      _selectedSymbol = null;
      _symbolCount = 0;
    });
  }

  Future updateAllTrackerPosition(List<TrackerModel> trackers) async {
    if (trackers != null) {
      for (TrackerModel tracker in trackers) {
        Symbol symbol = controller.symbols.firstWhere((element) => element.data["trackerId"] == tracker.id, orElse: () {
          print("no matching element in symbols: ${tracker.id}");
          return null;
        });
        if (symbol != null) {
          _selectedSymbol = symbol;
          await _updateSelectedTracker(
            SymbolOptions(
              geometry: LatLng(
                tracker.coordinates.latitude,
                tracker.coordinates.longitude,
              ),
            ),
          );
        }
      }
    }
  }

  Future _updateTrackerPosition(int trackerId, LatLng coordinates) async {
    if (coordinates != null && trackerId != null) {
      _selectedSymbol = controller.symbols.firstWhere((element) => element.data["trackerId"] == trackerId);
      await _updateSelectedTracker(
        SymbolOptions(
          geometry: LatLng(
            coordinates.latitude,
            coordinates.longitude,
          ),
        ),
      );
    }
  }

  Future updateTracker(TrackerModel trackerModel) async {
    if (trackerModel != null) {
      await removeTracker(trackerModel.id);
      await addTracker(trackerModel);
    }
  }

  Future hideTrackersById(List<int> trackerIds) async {
    if (trackerIds != null) {
      for (Symbol symbol in controller.symbols) {
        if (trackerIds.contains(symbol.data["trackerId"])) {
          _selectedSymbol = symbol;
          await _updateSelectedTracker(
            SymbolOptions(iconOpacity: 0.0),
          );
        }
      }
      ;
    }
  }

  Future showTrackersById(List<int> trackerIds) async {
    if (trackerIds != null) {
      for (Symbol symbol in controller.symbols) {
        if (trackerIds.contains(symbol.data["trackerId"])) {
          _selectedSymbol = symbol;
          await _updateSelectedTracker(
            SymbolOptions(iconOpacity: 1.0),
          );
        }
      }
      ;
    }
  }

  Future _showAllTracker() async {
    for (Symbol symbol in controller.symbols) {
      _selectedSymbol = symbol;
      await _updateSelectedTracker(
        SymbolOptions(iconOpacity: 1.0),
      );
    }
    ;
  }

  void _getLatLng() async {
    LatLng latLng = await controller.getSymbolLatLng(_selectedSymbol);
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(latLng.toString()),
      ),
    );
  }

  LatLngBounds boundsFromLatLngList() {
    if (widget.trackers.isEmpty) return LatLngBounds();

    List<LatLng> list = [];
    widget.trackers.forEach((element) {
      list.add(element.coordinates);
    });
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }

    //if no data provided, hungary bounds default
    if (x0 == null || y0 == null || x1 == null || y1 == null) {
      x0 = 46;
      y0 = 16;
      x1 = 47;
      y1 = 22;
    }

    // OPTIONAL - Add some extra "padding" for better map display
    double padding = 1;
    double south = x0 - padding;
    double west = y0 - padding;
    double north = x1 + padding;
    double east = y1 + padding;

    LatLng northeast = LatLng(north, east);
    LatLng southwest = LatLng(south, west);

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  LatLng initialPosition() {
    if (widget.trackers.isNotEmpty)
      return widget.trackers.first.coordinates;
    else
      return LatLng(47.51, 19.05);
  }

  @override
  Widget build(BuildContext context) {
    return MapboxMap(
      accessToken: widget.accessToken,
      onMapCreated: _onMapCreated,
      onStyleLoadedCallback: onStyleLoadedCallback,
      onMapClick: _onMapClicked,
      initialCameraPosition: CameraPosition(
        target: initialPosition(),
        zoom: 11.0,
      ),
      minMaxZoomPreference: MinMaxZoomPreference(5, 16),
      //cameraTargetBounds: CameraTargetBounds(boundsFromLatLngList()),
    );
  }
}
