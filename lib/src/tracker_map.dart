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
import 'package:mapbox_gl/src/Constants.dart';

import 'tracker_model.dart';

import 'package:image/image.dart' as image;
import 'package:flutter/services.dart';


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
   * If I click on the map it returns the coordinate of the nearest route, if it is more than 20 meters away it returns the coordinate of the point where we clicked
   */
  void _onMapClicked(Point<double> point, LatLng latLng) {}

  /**
   * Once loaded, the map draws the pre-specified route and indicates the Start-Stop event
   */
  void onStyleLoadedCallback() {
    if (widget.trackers != null && widget.trackers.isNotEmpty) {
      _addImages(widget.trackers);
      List<LatLng> coordinates = new List<LatLng>();
      widget.trackers.forEach((element) {
        coordinates.add(element.coordinates);
      });
      controller.moveCamera(CameraUpdate.newLatLngBounds(Constants.boundsFromLatLngList(coordinates)));
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
    var markerImage = data["markerImage"];
    widget.trackerPressCallback(TrackerModel(trackerId, symbol.options.geometry, symbol.options.iconColor, markerImage, symbol.options.iconImage));
  }

  Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    image.Image baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
    image.Image resizeImage = image.copyResize(baseSizeImage, height: height, width: width);
    ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
  Future _makeIconFromSVGAsset(String path, String markerImagePath, String name, String color) async {
    final recorder = new ui.PictureRecorder();
    final canvas = new Canvas(
        recorder,
        new Rect.fromPoints(
            new Offset(0.0, 0.0), new Offset(90.0, 90.0)));
    final String assetName = path;
    final svgString = await rootBundle.loadString(assetName);
    final DrawableRoot svgRoot = await svg.fromSvgString(svgString, "");
    final ui.Picture picture = svgRoot.toPicture(colorFilter: ColorFilter.mode(Constants.fromHex(color), BlendMode.srcIn));
    final ui.Image _image = await picture.toImage(90, 90);
    canvas.drawImage(_image, Offset(0.0,0.0), new Paint());
    if (markerImagePath != null && markerImagePath != "") {
      final ui.Image _markerImage = await getUiImage(markerImagePath, 50, 50);
      Paint paint = new Paint();
      paint.colorFilter = ColorFilter.mode(Constants.fromHex("#ffffff"), BlendMode.srcIn);
      canvas.drawImage(_markerImage, Offset(20.0, 20.0), paint);
    }
    final mergedPicture = recorder.endRecording();
    final img = await mergedPicture.toImage(90, 90);
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
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
    String trackerIconName = getTrackerIconName("marker_",tracker.id,tracker.color);
    await _makeIconFromSVGAsset(tracker.iconImage, tracker.markerImage, trackerIconName, trackerColor);
    await _imageAdded(tracker);
  }

  String getTrackerIconName(String base, int id, String color) {
    return  base + id.toString() + color.replaceAll("#", "_");
  }

  Future _imageAdded(TrackerModel tracker) async {
    _imageCount = 0;
    print("_imageAdded " + tracker.id.toString());
    String trackerIconName = getTrackerIconName("marker_",tracker.id,tracker.color);
    await controller.addSymbol(Constants.getSymbolOptions(trackerIconName, tracker.coordinates, tracker.id.toString()), {'trackerId': tracker.id, 'markerImage': tracker.markerImage});
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

  LatLngBounds boundsFromLatLngList(){
    return Constants.boundsFromLatLngList(widget.trackers.map((e) => e.coordinates));
  }

  Future _addImages(List<TrackerModel> trackers) async {
    if (widgetTrackers == null) widgetTrackers = new List<TrackerModel>();
    widgetTrackers.addAll(trackers);
    _imageCount = 0;
    for (TrackerModel tracker in trackers) {
      String trackerColor = tracker.color;
      String trackerIconName = getTrackerIconName("marker_",tracker.id,tracker.color);
      await _makeIconFromSVGAsset(tracker.iconImage, tracker.markerImage, trackerIconName,  trackerColor);
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
        String trackerIconName = getTrackerIconName("marker_",tracker.id,tracker.color);
        tracker.iconImage = trackerIconName;
        controller.addSymbol(Constants.getSymbolOptions(tracker.iconImage, tracker.coordinates, tracker.id.toString()), {'trackerId': tracker.id, 'markerImage': tracker.markerImage});
      });

      setState(() {
        _symbolCount += trackers.length;
      });
    }
  }

  Future removeTracker(int trackerId) async {
    if (trackerId != null) {
      widgetTrackers.removeWhere((element) => element.id == trackerId);
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
      styleString: Constants.MAP_TILE_JSON,
      initialCameraPosition: CameraPosition(
        target: initialPosition(),
        zoom: 11.0,
      ),
      minMaxZoomPreference: MinMaxZoomPreference(5, 16),
      //cameraTargetBounds: CameraTargetBounds(boundsFromLatLngList()),
    );
  }
}
