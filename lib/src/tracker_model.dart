
import '../mapbox_gl.dart';

class TrackerModel {
  int id;
  String iconImage;
  String color;
  LatLng coordinates;

  TrackerModel(int trackerId, LatLng coordinates, String color, String image) {
    this.id = trackerId;
    this.coordinates = coordinates;
    this.color = color;
    this.iconImage = image;
  }
}
