# mapbox_gl_example

Demonstrates how to use the mapbox_gl plugin.

## pubspec.yaml
A pubspec.yaml fájlba kellenek az egyedi assetek, ezek a dedikált méretek voltak megadva az eredetiben, így én is ezeket használtam

assets/symbols -> 40x40px
assets/symbols/2.0x -> 120x120px
assets/symbols/3.0x -> 180x180px

assets:
  - assets/symbols/custom-icon.png
  - assets/symbols/2.0x/custom-icon.png
  - assets/symbols/3.0x/custom-icon.png
  - assets/symbols/stop.png
  - assets/symbols/2.0x/stop.png
  - assets/symbols/3.0x/stop.png
  - assets/symbols/start.png
  - assets/symbols/2.0x/start.png
  - assets/symbols/3.0x/start.png
  - assets/symbols/map_poi.png
  - assets/symbols/2.0x/map_poi.png
  - assets/symbols/3.0x/map_poi.png

## main.dart

Ide kell írni a mapbox access token, ami majd átadja a nativ platformoknak
Ez még nincs bekötve, nativan is meg van adva, de addig az enyémmel működik
static const String ACCESS_TOKEN = "pk.eyJ1IjoibmFneWlzdHZhbiIsImEiOiJja2lxczJ0dXgxenJjMzFxajVmamJxdGJiIn0.R1muCmqEhEJLAzGPMhcC2A";

Nativan:
iOS
MapboxMapController.init-be
MGLAccountManager.accessToken = "pk.eyJ1IjoibmFneWlzdHZhbiIsImEiOiJja2lxczJ0dXgxenJjMzFxajVmamJxdGJiIn0.R1muCmqEhEJLAzGPMhcC2A"

Android
MapboxMapController construktorába
Mapbox.getInstance(context, "pk.eyJ1IjoibmFneWlzdHZhbiIsImEiOiJja2lxczJ0dXgxenJjMzFxajVmamJxdGJiIn0.R1muCmqEhEJLAzGPMhcC2A"/*accessToken!=null ? accessToken : getAccessToken(context)*/);

## tracker_symbol.dart
Itt találhatók a tracker kirajzoláshoz szükséges függvények

## route_page.dart
Itt találhatók az útvonal kirajzoláshoz szükséges függvények

## event_symbol.dart
Itt találhatók az esemény kirajzoláshoz szükséges függvények
