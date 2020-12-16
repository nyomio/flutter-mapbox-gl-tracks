package com.mapbox.mapboxgl.nyomio.components

import android.content.Context
import android.graphics.Color
import com.mapbox.geojson.Feature
import com.mapbox.geojson.Point
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.features
import com.mapbox.mapboxgl.nyomio.marker.downloadImage
import com.mapbox.mapboxgl.nyomio.marker.getRoundedCornerBitmapWithBorder
import com.mapbox.mapboxgl.nyomio.model.TrackerModel
import com.mapbox.mapboxsdk.annotations.PolygonOptions
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.maps.Style
import com.mapbox.mapboxsdk.style.expressions.Expression
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.layers.SymbolLayer

/**
 * Figyelmeztetések layere a mapon
 */
fun MapboxMapController.setUpAlertLayer(loadedStyle: Style?) {
    loadedStyle?.addLayer(SymbolLayer(ALERT_LAYER_ID, GEOJSON_SOURCE_ID)
            .withProperties(
                    PropertyFactory.iconImage(
                            Expression.get(
                                    PROPERTY_NAME
                            )
                    ),
                    PropertyFactory.iconSize(1f),
                    PropertyFactory.iconAllowOverlap(true),
                    PropertyFactory.iconOffset(
                            arrayOf(
                                    0f,
                                    -8f
                            )
                    )
            )
            .withFilter(
                    Expression.eq(
                            Expression.get(
                                    PROPERTY_VISIBLE
                            ), Expression.literal(true)
                    )
            )
    )
}

/**
 * Trackerek layere a mapon
 */
fun MapboxMapController.setUpMarkerLayer(loadedStyle: Style?) {
    loadedStyle?.addLayer(SymbolLayer(MARKER_LAYER_ID, GEOJSON_SOURCE_ID)
            .withProperties(
                    PropertyFactory.iconImage(
                            Expression.get(
                                    PROPERTY_NAME
                            )
                    ),
                    PropertyFactory.iconSize(1f),
                    PropertyFactory.iconAllowOverlap(true),
                    PropertyFactory.iconOffset(
                            arrayOf(
                                    0f,
                                    -8f
                            )
                    )
            )
            .withFilter(
                    Expression.eq(
                            Expression.get(
                                    PROPERTY_VISIBLE
                            ), Expression.literal(true)
                    )
            )
    )
}

/**
 * Figyelmeztetés annotation feature készítése a MapBox maphoz
 */
fun MapboxMapController.createAlertAnnotation(name: String, type: String, latLng: LatLng) {
    val f = Feature.fromGeometry(Point.fromLngLat(latLng.longitude, latLng.latitude))
    f.addStringProperty(PROPERTY_NAME, name)
    f.addBooleanProperty(PROPERTY_VISIBLE, true)
    f.addStringProperty(PROPERTY_CAPITAL, name.plus("_error"))
    f.addStringProperty(PROPERTY_TYPE, type)
    features.add(f)
}

/**
 * Tracker annotation feature készítése a MapBox maphoz
 */
fun MapboxMapController.createTrackerAnnotation(id: Int, name: String, type: String, latLng: LatLng) {
    val f = Feature.fromGeometry(Point.fromLngLat(latLng.longitude, latLng.latitude))
    f.addStringProperty(PROPERTY_ID, id.toString())
    f.addStringProperty(PROPERTY_NAME, name)
    f.addBooleanProperty(PROPERTY_VISIBLE, true)
    f.addStringProperty(PROPERTY_CAPITAL, name.plus("_tracker"))
    f.addStringProperty(PROPERTY_TYPE, type)
    features.add(f)
}

/**
 * Tracker annotation feature módosítása a MapBox maphoz
 */
fun MapboxMapController.updateTrackerAnnotation(trackerModel: TrackerModel): Feature {
    val f = Feature.fromGeometry(Point.fromLngLat(trackerModel.latlong.long, trackerModel.latlong.lat))
    f.addStringProperty(PROPERTY_ID, trackerModel.id.toString())
    f.addStringProperty(PROPERTY_NAME, trackerModel.name)
    f.addBooleanProperty(PROPERTY_VISIBLE, true)
    f.addStringProperty(PROPERTY_CAPITAL, trackerModel.name.plus("_tracker"))
    f.addStringProperty(PROPERTY_TYPE, "user")
    return f
}

/**
 * Tracker annotation képének módosítása
 */
fun MapboxMapController.updateImages(context: Context, trackers: List<TrackerModel>?) {
    trackers?.forEach { tracker ->
        downloadImage(context, tracker.name!!, tracker.image ?: "https://kep.cdn.indexvas.hu/1/0/293/2935/29352/2935222_c262c2241c8e4b988d4d743bd7c32d52_wm.jpg") {
            if (it != null) {
                if (mapboxMap != null && mapboxMap?.style != null) {
                    registrar.activity().runOnUiThread {
                        if (mapboxMap?.style?.getImage(tracker.name!!) != null)
                            mapboxMap?.style?.removeImage(tracker.name!!)
                        if (mapboxMap != null && mapboxMap?.style != null) {
                            val bmp = getRoundedCornerBitmapWithBorder(it, tracker.color!!)
                            if (bmp != null)
                                mapboxMap?.style?.addImageAsync(tracker.name!!, bmp!!)
                        }
                        refreshSource()
                    }
                }
            }
        }
    }
}
/**
 * Tracker annotation kép hozzáadása
 */
fun MapboxMapController.addImage(context: Context, tracker: TrackerModel) {
        downloadImage(context, tracker.name!!, tracker.image ?: "https://kep.cdn.indexvas.hu/1/0/293/2935/29352/2935222_c262c2241c8e4b988d4d743bd7c32d52_wm.jpg") {
            if (it != null) {
                if (mapboxMap != null && mapboxMap?.style != null) {
                    registrar.activity().runOnUiThread {
                        removeImage(tracker)
                        if (mapboxMap != null && mapboxMap?.style != null){
                            val bmp = getRoundedCornerBitmapWithBorder(it, tracker.color!!)
                            if (bmp != null)
                                mapboxMap?.style?.addImageAsync(tracker.name!!, bmp!!)
                        }
                        refreshSource()

                    }
                }
            }
        }
}
/**
 * Tracker annotation kép törlése
 */
fun MapboxMapController.removeImage(trackerModel: TrackerModel){
    if (mapboxMap?.style?.getImage(trackerModel.name!!) != null)
        mapboxMap?.style?.removeImage(trackerModel.name!!)
    refreshSource()

}

/**
 * Kör polygon hozzáadása, jelenleg nem használjuk, mivel olyan polygonokat használunk aminek megvan adva minden pontja, így nem kell kört generálni
 */
fun MapboxMapController.addCirclePlace(centerX: Double?, centerY: Double?, radius: Double?, slides: Int?) {
    mapboxMap?.addPolygon(
            generatePerimeter(
                    LatLng(centerX ?: 47.505482, centerY ?: 19.084451),
                    radius ?: 0.015,
                    slides ?: 36
            )!!
    )
}

/**
 * Kör generálása koordináta alapján
 */
private fun generatePerimeter(
        centerCoordinates: LatLng,
        radiusInKilometers: Double,
        numberOfSides: Int
): PolygonOptions? {
    val positions: MutableList<LatLng> = mutableListOf()
    val distanceX =
            radiusInKilometers / (111.319 * Math.cos(centerCoordinates.latitude * Math.PI / 180))
    val distanceY = radiusInKilometers / 110.574
    val slice = 2 * Math.PI / numberOfSides
    var theta: Double
    var x: Double
    var y: Double
    var position: LatLng
    for (i in 0 until numberOfSides) {
        theta = i * slice
        x = distanceX * Math.cos(theta)
        y = distanceY * Math.sin(theta)
        position = LatLng(
                centerCoordinates.latitude + y,
                centerCoordinates.longitude + x
        )
        positions.add(position)
    }
    return PolygonOptions()
            .addAll(positions)
            .fillColor(Color.BLUE)
            .alpha(0.4f)
}
