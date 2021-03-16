
class Trip {
  final int id;
  final String pathColor;
  final String startColor;
  final String endColor;
  final List<GpsLocation> coordinates;
  final int waitingTime;


  Trip(this.id, this.pathColor, this.startColor, this.endColor, this.coordinates, this.waitingTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          pathColor == other.pathColor &&
          startColor == other.startColor &&
          endColor == other.endColor &&
          coordinates == other.coordinates &&
          waitingTime == other.waitingTime;

  @override
  int get hashCode => id.hashCode ^ pathColor.hashCode ^ startColor.hashCode ^ endColor.hashCode ^ coordinates.hashCode ^ waitingTime.hashCode;
}

class GpsLocation {
  final double lat;
  final double long;
  final double heading;
  final double alt;
  final double speed;
  final int time;

  GpsLocation(this.lat, this.long, this.heading, this.alt, this.speed, this.time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GpsLocation && runtimeType == other.runtimeType && lat == other.lat && long == other.long && heading == other.heading && alt == other.alt && speed == other.speed && time == other.time;

  @override
  int get hashCode => lat.hashCode ^ long.hashCode ^ heading.hashCode ^ alt.hashCode ^ speed.hashCode ^ time.hashCode;
}

