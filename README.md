# Flutter Mapbox GL

## iOS 

- A main projektbe, ios oldalon fel kell venni az alábbi paramétereket az info.plistbe, mert különben crashelhet az alkalmazás.
- A MapBox Gl plugin alapvetően használja a telefon lokációját
```
   <key>NSLocationWhenInUseUsageDescription</key>
	<string>valami szöveg, hogy miért kéred</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>valami szöveg, hogy miért kéred</string>
	<key>NSLocationAlwaysUsageDescription</key>
	<string>valami szöveg, hogy miért kéred</string>
```

## Symbol

- Ajánlott 3 féle méretű ikont felvenni a térképhez, az alábbi strukúrában:

```
   assets:
     - assets/icon.png 40x40px PNG kép
     - assets/2.0x/icon.png 120x120px PNG kép
     - assets/3.0x/icon.png 180x180px PNG kép
```

## MapWithTrip

- A Trip külön widgetre került, az alábbi módon kell inicializálni:
```
     MapWithTrip(
              tripData,
              Constants.MAPBOX_ACCESS_TOKEN,
              "assets/start.png",
              "assets/stop.png",
              _onMapClick,
              _onMapLoaded
          )

     tripData => Trip object
     Constants.MAPBOX_ACCESS_TOKEN => MapboxMap Access token
     "assets/start.png" => A start ikon elérési útja
     "assets/stop.png" => A stop ikon elérési útja
     _onMapClick => pl: void _onMapClick(GpsLocation gpsLocation) {
                             print(gpsLocation);
                        }
     Ha a térképen az útvonalra kattintunk visszaadja a legközelebbi GpsLocation objectet, ha 20 méternél messzebb van akkor pedig az adott pont koordinátáit
     _onMapLoaded => pl: void _onMapLoaded() {
                            print("A térkép inicializálva van");
                         }
     Jelzi amikor teljesen betöltött a térkép.

```
