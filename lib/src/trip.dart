
class Trip {
  final int id;
  final String color;
  final List<GpsLocation> coordinates;
  final int waitingTime;

  Trip(this.id, this.color, this.coordinates, this.waitingTime);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Trip &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              color == other.color &&
              coordinates == other.coordinates &&
              waitingTime == other.waitingTime;

  @override
  int get hashCode => id.hashCode ^ color.hashCode ^ coordinates.hashCode ^ waitingTime.hashCode;
}

class GpsLocation {
  final double lat;
  final double long;
  final double alt;
  final double heading;
  final double speed;
  final int time;

  GpsLocation(this.lat, this.long, this.alt, this.heading, this.speed, this.time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GpsLocation &&
              runtimeType == other.runtimeType &&
              lat == other.lat &&
              long == other.long &&
              alt == other.alt &&
              heading == other.heading &&
              speed == other.speed &&
              time == other.time;

  @override
  int get hashCode => lat.hashCode ^ long.hashCode ^ alt.hashCode ^ heading.hashCode ^ speed.hashCode ^ time.hashCode;
}