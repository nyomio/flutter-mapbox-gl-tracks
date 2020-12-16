package com.mapbox.mapboxgl.nyomio.components

import android.graphics.PointF
import android.graphics.RectF
import com.mapbox.geojson.Feature
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxsdk.maps.MapboxMap


/**
 * Térképre longclick
 * Methodchannelen keresztül elküldi az adott elem id-ját attól függően, hogy a koordináta egy trackerre vagy alertre mutat
 * Ha egyikre sem akkor az adott koordinátákat
 */
fun MapboxMapController.onMapLongClick() = MapboxMap.OnMapLongClickListener {
    val pointf = mapboxMap!!.projection.toScreenLocation(it)
    val rectF = RectF(pointf.x - 10, pointf.y - 10, pointf.x + 10, pointf.y + 10)
    var featureList: List<Feature> = mapboxMap?.queryRenderedFeatures(rectF, MARKER_LAYER_ID)?: listOf()
    var featureAlertList: List<Feature> = mapboxMap?.queryRenderedFeatures(rectF, ALERT_LAYER_ID)?: listOf()
    when {
        featureList.isNotEmpty() -> { markerLongClick(featureList) }

        featureAlertList.isNotEmpty() -> { alertLongClick(featureAlertList)}

        else -> { mapLongClick(it) }
    }
    return@OnMapLongClickListener true
}

/**
 * Térképre click
 * Methodchannelen keresztül elküldi az adott elem id-ját attól függően, hogy a koordináta egy trackerre vagy alertre mutat
 * Ha egyikre sem akkor az adott koordinátákat
 */
fun MapboxMapController.onMapClick() = MapboxMap.OnMapClickListener {
    val pointf: PointF = mapboxMap!!.projection.toScreenLocation(it)
    val rectF = RectF(pointf.x - 10, pointf.y - 10, pointf.x + 10, pointf.y + 10)
    var featureList: List<Feature> = mapboxMap?.queryRenderedFeatures(rectF, MARKER_LAYER_ID)?: listOf()
    var featureAlertList: List<Feature> = mapboxMap?.queryRenderedFeatures(rectF, ALERT_LAYER_ID)?: listOf()
    when {
        featureList.isNotEmpty() -> { markerClick(featureList) }

        featureAlertList.isNotEmpty() -> { alertClick(featureAlertList) }

        else -> { mapClick(it) }
    }
    return@OnMapClickListener true
}

/**
 * Polygon / Place click
 * Methodchannelen keresztül elküldi a polygon / place id-ját a flutternek
 */
fun MapboxMapController.onPolygonClick() = MapboxMap.OnPolygonClickListener {
    methodChannel?.invokeMethod("map_polygon_click", it.id )
}