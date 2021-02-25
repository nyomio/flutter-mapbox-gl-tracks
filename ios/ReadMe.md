## Térkép használatához el kell kérni a helymeghatározási engedélyeket a main appban.

![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.50.23.png "Info.plist")

xml:
```
	<key>NSLocationAlwaysUsageDescription</key>
	<string>szeretnénk használni a lokációd</string>
	<key>NSLocationWhenInUseUsageDescription</key>
	<string>szeretnénk használni a lokációd</string>
	<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
	<string>szeretnénk használni a lokációd</string>
```

## Többnyelvű engedélyek az Info.plist-ben

Hozzunk létre egy **InfoPlist.strings** fájlt.
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.42.36.png "InfoPlist.strings")
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.43.23.png "InfoPlist.strings")

Ha elkészítettük a fájlt válasszuk ki és jobb oldalt látunk egy **Localize..** gombot, ott válasszuk ki az English-t
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.43.37.png "InfoPlist.strings")

Írjuk bele miket szeretnénk több nyelven elérhetővé tenni. 
**Fontos: mindig az Info.plist xml-ben szereplő kulcsot kell itt is megadni kulcsnak. pl: "NSLocationAlwaysUsageDescription" **
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.47.03.png "InfoPlist.strings")

Ezután menjünk a projekt nézetre (legfelső fájl).
Itt válasszuk ki a **Projects** részben szereplő fájlt.
Az **Info** oldalon tudunk új nyelveket hozzáadni, itt fel fogja dobni milyen fájlokat szeretnénk nyelvesíteni, maradhat a kijelölés a storyboard és ezen az InfoPlist.strings fájlokon.
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.47.14.png "InfoPlist.strings")

Ekkor meg fog jelenni a többi InfoPlist.strings nyelvi fájl is és be tudjuk írni a megfelelő fordításokat.
A telefonon vagy szimulátoron a beállításokba tudjuk változtatni a telefon nyelvét és láthatjuk, hogy változik a szöveg.
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.47.52.png "InfoPlist.strings")
![alt text](https://raw.githubusercontent.com/nyomio/flutter-mapbox-gl-tracks/trip_map/example/Képernyőfotó%202021-02-25%20-%202.47.30.png "InfoPlist.strings")





