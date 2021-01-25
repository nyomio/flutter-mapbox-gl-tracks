package com.mapbox.mapboxgl.nyomio.components

import android.util.Log
import com.mapbox.geojson.FeatureCollection
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.featureCollection
import com.mapbox.mapboxgl.nyomio.features
import com.mapbox.mapboxgl.nyomio.model.ErrorModel
import com.mapbox.mapboxsdk.geometry.LatLng

/**
 * Jelenleg nem használjuk
 * Különböző jelzéseket tud kirakni a térképre a felhasználó, mint a WAZE-ben
 */
fun MapboxMapController.addAlerts(list: List<ErrorModel>) {
    if (list.isNotEmpty()) {
        list.forEach { item ->
            Log.wtf("ITEM", item.toString())
            createAlertAnnotation("utlezaras", "error", LatLng(47.505452, 19.075585))
        }
        featureCollection = FeatureCollection.fromFeatures(features)
        refreshSource()
    }
}