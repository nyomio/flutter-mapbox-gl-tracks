import 'package:mapbox_gl/mapbox_gl.dart';

class Trip {
  int id;
  String color;
  List<TrackerEvent> events;
  List<Coordinate> coordinates;

  Trip(int tripId, String tripColor, List<TrackerEvent> trackerEvents, List<Coordinate> tripCoordinates) {
    this.id = tripId;
    this.coordinates = tripCoordinates;
    this.color = tripColor;
    this.events = trackerEvents;
  }
}

class Coordinate {
  double lat;
  double long;
  int durationSec;
  int time;
}

class TrackerEvent {
  double lat;
  double long;
  int eventType;
  int durationSec;
  int time;
}
