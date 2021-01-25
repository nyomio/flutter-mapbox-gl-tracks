import 'package:mapbox_gl/mapbox_gl.dart';

class Trip {
  int id;
  String color;
  List<GpsLocation> coordinates;

  Trip(int tripId, String tripColor, List<GpsLocation> tripCoordinates) {
    this.id = tripId;
    this.coordinates = tripCoordinates;
    this.color = tripColor;
  }
}

class GpsLocation {
  double lat;
  double long;
  double heading;
  double alt;
  double speed;
  int time;

  GpsLocation(double lat, double long, double heading, double alt, double speed, int time) {
    this.lat = lat;
    this.long = long;
    this.heading = heading;
    this.alt = alt;
    this.speed = speed;
    this.time = time;
  }
}

