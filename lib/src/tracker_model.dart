
import '../mapbox_gl.dart';

class TrackerModel{
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is TrackerModel && runtimeType == other.runtimeType && id == other.id && iconImage == other.iconImage && color == other.color && coordinates == other.coordinates;

  @override
  int get hashCode => id.hashCode ^ iconImage.hashCode ^ color.hashCode ^ coordinates.hashCode;


}
