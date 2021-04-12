
import '../mapbox_gl.dart';

class TrackerModel{
  int id;
  String markerImage;
  String iconImage;
  String color;
  LatLng coordinates;

  TrackerModel(int trackerId, LatLng coordinates, String color, String iconImage, String markerImage) {
    this.id = trackerId;
    this.coordinates = coordinates;
    this.color = color;
    this.markerImage = iconImage;
    this.iconImage = markerImage;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TrackerModel && runtimeType == other.runtimeType && id == other.id && markerImage == other.markerImage && iconImage == other.iconImage && color == other.color && coordinates == other.coordinates;

  @override
  int get hashCode => id.hashCode ^ markerImage.hashCode ^ iconImage.hashCode ^ color.hashCode ^ coordinates.hashCode;


}
