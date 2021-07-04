
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:ui';
import 'package:mapbox_gl/mapbox_gl.dart';

class Constants {

  static String MAP_TILE_JSON = "https://tiles.nyom.io/styles/osm-bright/style.json";
  static double getSymbolIconSize() {
    if (Platform.isAndroid) {
      return 1.0;
    } else if (Platform.isIOS) {
      return 0.5;
    }
  }

  static SymbolOptions getSymbolOptions(String iconImage, LatLng coordinates, String name) {
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
        iconSize: getSymbolIconSize(),
        textField: "",
        textSize: 12.0,
        textAnchor: "top",
        textColor: "#00000000");
  }

  static LatLngBounds boundsFromLatLngList(List<LatLng> coordinates) {
    //if (coordinates == null || coordinates.isEmpty) return LatLngBounds();

    double x0, x1, y0, y1;
    for (LatLng latLng in coordinates) {
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

  /**
   * Calculates the distance between two coordinates
   */
  static double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}