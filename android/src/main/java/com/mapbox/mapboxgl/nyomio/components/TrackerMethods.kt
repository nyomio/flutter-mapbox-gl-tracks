package com.mapbox.mapboxgl.nyomio.components

import com.mapbox.geojson.FeatureCollection
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.*
import com.mapbox.mapboxgl.nyomio.model.TrackerModel
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource


/**
 * Tracker annotation térképes láthatóságának állítása
 */
fun MapboxMapController.setTrackerVisibility(id: Int, visible: Boolean) {
    for (i in 0 until (features?.size ?: 0)) {
        if (features!![i].getStringProperty(PROPERTY_ID) == id.toString()) {
            features!![i].removeProperty(PROPERTY_VISIBLE)
            features!![i].addBooleanProperty(PROPERTY_VISIBLE, visible)
        }
    }

    if (!features.isNullOrEmpty()) {
        registrar.activity().runOnUiThread {
            refreshSource()
        }
    }
}

/**
 * Tracker annotation felvétele a térképre
 */
fun MapboxMapController.addTracker(tracker: TrackerModel?) {
    if (tracker != null) {
        if (trackers.isNullOrEmpty())
            trackers = mutableListOf()
        trackers.add(tracker)
        if (!trackers.isNullOrEmpty()) {
            trackers.forEach { item ->
                if (features.firstOrNull { it.getStringProperty(PROPERTY_ID).toInt() == item.id } == null)
                    createTrackerAnnotation(item.id!!, item.name!!, "user", LatLng(item.latlong.lat, item.latlong.long))
            }
            featureCollection = FeatureCollection.fromFeatures(features)
            registrar.activity().runOnUiThread {
                if (isTrackerRemove) {
                    isTrackerRemove = false
                    mapboxMap?.clear()
                    setUpData(featureCollection)
                }
                else
                    setUpData(featureCollection)

            }
        }
    }
}

/**
 * Tracker annotation-ök felvétele a térképre
 */
fun MapboxMapController.addTrackers(list: MutableList<TrackerModel>?): Boolean? {
    require(!list.isNullOrEmpty()) {
        "addTrackers trackers is null or empty"
    }
    trackers = list
    if (!trackers.isNullOrEmpty()) {
        trackers.forEach { item ->
            if (features.firstOrNull { it.getStringProperty(PROPERTY_ID).toInt() == item.id } == null)
                createTrackerAnnotation(item.id!!, item.name!!, "user", LatLng(item.latlong.lat, item.latlong.long))
        }
        featureCollection = FeatureCollection.fromFeatures(features)
        registrar.activity().runOnUiThread {
            if (isTrackerRemove) {
                isTrackerRemove = false
                mapboxMap?.clear()
                setUpData(featureCollection)
            }
            else
                setUpData(featureCollection)

        }
    }
    return true
}
/**
 * Térkép adatainak beállítása, pl trackerek, placek
 */
fun MapboxMapController.setUpData(collection: FeatureCollection?) {
    featureCollection = collection
    if (mapboxMap != null) {
        if (mapboxMap != null && mapboxMap?.style != null)
            if (mapboxMap?.style?.getLayer(MARKER_LAYER_ID) == null)
                setUpMarkerLayer(mapboxMap?.style)

        if (mapboxMap != null && mapboxMap?.style != null)
            if (mapboxMap?.style?.getLayer(ALERT_LAYER_ID) == null)
                setUpAlertLayer(mapboxMap?.style)

        places?.forEach {
            if (mapboxMap != null && mapboxMap?.style != null) {
                if (mapboxMap?.polygons?.firstOrNull { poly -> poly.id == it.id.toLong() } == null)
                    addPlace(it)
            }
        }
        if (mapboxMap != null && mapboxMap?.style != null)
            updateImages(registrar.activeContext(),trackers)
    }
}
/**
 * Térkép adatainak módosítása, pl trackerek
 */
fun MapboxMapController.refreshSource() {
    if (featureCollection != null && mapboxMap?.style?.isFullyLoaded == true) {
        if (mapboxMap?.style?.sources?.firstOrNull { it.id == GEOJSON_SOURCE_ID } != null) {
            mapboxMap?.style?.getSourceAs<GeoJsonSource>(GEOJSON_SOURCE_ID)?.setGeoJson(featureCollection)
        } else {
            mapboxMap?.style?.addSource(GeoJsonSource(GEOJSON_SOURCE_ID, featureCollection))
        }
    }
}
/**
 * Tracker annotation törlése a térképről
 */
fun MapboxMapController.removeTracker(id: Int) {
    if (trackers.isNotEmpty()) {
        val t: TrackerModel? = trackers.first {
            it.id == id
        }
        if (t != null) {
            features.removeAll {
                it.getStringProperty(PROPERTY_ID).toInt() == id
            }
            trackers.removeAll {
                it.id == id
            }
            isTrackerRemove = true
            if (!trackers.isNullOrEmpty()) {
                trackers.forEach { item ->
                    if (features.firstOrNull { it.getStringProperty(PROPERTY_ID).toInt() == item.id } == null)
                        createTrackerAnnotation(item.id!!, item.name!!, "user", LatLng(item.latlong.lat, item.latlong.long))
                }
                featureCollection = FeatureCollection.fromFeatures(features)
                registrar.activity().runOnUiThread {
                    if (isTrackerRemove) {
                        isTrackerRemove = false
                        mapboxMap?.clear()
                        setUpData(featureCollection)
                    }
                    else
                        setUpData(featureCollection)

                }
            }
        }
    }
}

/**
 * Tracker annotation frisstése a térképen
 */
fun MapboxMapController.updateTracker(trackerModel: TrackerModel?): Boolean? {
    require(trackerModel != null) {
        "updateTracker -> tracker is null"
    }
    for (i in 0 until (features.size)) {
        if (features[i].getStringProperty(PROPERTY_ID) == trackerModel.id.toString()) {
            features[i] = updateTrackerAnnotation(trackerModel)
        }
    }

    for (i in 0 until (trackers?.size ?: 0)) {
        if (trackers[i].id == trackerModel.id) {
            trackers[i] = trackerModel
        }
    }

    if (!features.isNullOrEmpty()) {
        if (!trackers.isNullOrEmpty()) {
            trackers.forEach { item ->
                if (features.firstOrNull { it.getStringProperty(PROPERTY_ID).toInt() == item.id } == null)
                    createTrackerAnnotation(item.id!!, item.name!!, "user", LatLng(item.latlong.lat, item.latlong.long))
            }
            featureCollection = FeatureCollection.fromFeatures(features)
            registrar.activity().runOnUiThread {
                if (isTrackerRemove) {
                    isTrackerRemove = false
                    mapboxMap?.clear()
                    setUpData(featureCollection)
                }
                else
                    setUpData(featureCollection)

            }
        }
        return true
    }
    return false
}