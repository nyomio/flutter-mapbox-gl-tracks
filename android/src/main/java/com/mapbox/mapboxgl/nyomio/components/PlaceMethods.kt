package com.mapbox.mapboxgl.nyomio.components

import android.graphics.Color
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.featureCollection
import com.mapbox.mapboxgl.nyomio.model.PlaceModel
import com.mapbox.mapboxgl.nyomio.model.PolygonModel
import com.mapbox.mapboxgl.nyomio.places
import com.mapbox.mapboxgl.nyomio.polygons
import com.mapbox.mapboxsdk.annotations.PolygonOptions
import com.mapbox.mapboxsdk.geometry.LatLng


/**
 * Place felvétele a térképre
 */
fun MapboxMapController.addPlace(list: PlaceModel?) {
    if (list != null) {
        if (!places.contains(list)) {
            places.add(list)
        }
        addPoly(PolygonModel(list.id.toLong(), list.latlongs, list.color))
    }

}

/**
 * Placek felvétele a térképre
 */
fun MapboxMapController.addPlaces(list: MutableList<PlaceModel>) {
    if (list.isNotEmpty()) {
        places = list
        list.forEach { item ->
            if (mapboxMap?.polygons?.firstOrNull { item.id.toLong() == it.id } == null)
                addPoly(PolygonModel(item.id.toLong(), item.latlongs, item.color))
        }
    }

}

/**
 * Polygonok felvétele a térképre
 */
fun MapboxMapController.addPolygons(list: List<PolygonModel>) {
    if (list.isNotEmpty()) {
        list.forEach { item ->
            addPoly(item)
        }
    }
}

/**
 * Polygon / Place törlése a térképről
 */
fun MapboxMapController.removePolygon(id: Int) {
    val poly = mapboxMap?.polygons?.first {
        it.id.toInt() == id
    }

    polygons.removeAll {
        it.id.toInt() == id
    }
    places.removeAll {
        it.id == id
    }

    if (poly != null) {
        registrar.activity().runOnUiThread {
            mapboxMap?.clear()
            setUpData(featureCollection)
        }
    }
}

/**
 * Polygon készítése
 */
fun MapboxMapController.addPoly(item: PolygonModel) {
    var coordinates = mutableListOf<LatLng>()
    item.positions.sortBy { it.order }
    item.positions.forEach {
        coordinates.add(LatLng(it.lat, it.long))
    }
    val options = PolygonOptions()
            .addAll(coordinates)
            .fillColor(Color.parseColor(item.color ?: "#f0ff0f"))
            .alpha(item.alpha)
    if (!polygons.contains(options.polygon))
        polygons.add(options.polygon)
    if (mapboxMap?.polygons?.contains(options.polygon) == false)
        mapboxMap?.addPolygon(options)?.setId(item.id)
    //refreshSource()
}