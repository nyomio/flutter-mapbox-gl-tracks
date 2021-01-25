package com.mapbox.mapboxgl.nyomio.components

import android.annotation.SuppressLint
import android.location.Location
import android.os.Looper
import android.util.Log
import com.google.gson.Gson
import com.google.gson.internal.LinkedTreeMap
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.currentPosition
import com.mapbox.mapboxgl.nyomio.fusedLocationClient
import com.mapbox.mapboxgl.nyomio.model.CoordinateModel
import com.mapbox.mapboxgl.nyomio.model.LatLngBoundsNyomio
import com.mapbox.mapboxgl.nyomio.model.typeToken
import com.mapbox.mapboxsdk.camera.CameraPosition
import com.mapbox.mapboxsdk.camera.CameraUpdateFactory
import com.mapbox.mapboxsdk.geometry.LatLng
import com.mapbox.mapboxsdk.geometry.LatLngBounds

/**
 * Kamera adott koordinátára pozícionálása
 * A ZOOM lehet null, ez esetben a jelenlegi térképen használt zoom az érvényes
 */
fun MapboxMapController.zoomToCoordinate(arguments: Any?): Boolean? {
    require(arguments != null)
    {
        "zoomToCoordinate arguments is null"
    }
    val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(arguments.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
    if (l != null && l.size > 0) {
        val lt = l[0]["lat"] as Double
        val rt = l[0]["long"] as Double
        var zoom = mapboxMap?.cameraPosition?.zoom ?: 17.0
        if (l[0].containsKey("zoom"))
            zoom = l[0]["zoom"] as? Double ?: mapboxMap?.cameraPosition?.zoom ?: 17.0
        val coordinate = LatLng(lt, rt)
        registrar.activity().runOnUiThread {
            mapboxMap?.easeCamera(CameraUpdateFactory.newCameraPosition(CameraPosition.Builder().zoom(zoom).target(coordinate).build()))
        }
        return true
    }
    return false
}

/**
 * Kamera pozícionálása az adott koordináta "keretre"
 * Ez arra jó ha egyszerre akarjuk látni az összes trackert, placet stb
 */
fun MapboxMapController.zoomToCoordinateBounds(arguments: Any?): Boolean? {
    require(arguments != null)
    {
        "zoomToCoordinateBounds arguments is null"

    }
    val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(arguments.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
    if (l != null && l.size > 0) {
        val lt = l[0]["leftTop"] as LinkedTreeMap<String, Any>
        val rt = l[0]["rightTop"] as LinkedTreeMap<String, Any>
        val lb = l[0]["leftBottom"] as LinkedTreeMap<String, Any>
        val rb = l[0]["rightBottom"] as LinkedTreeMap<String, Any>
        val leftTop = LatLng(lt["lat"] as Double, lt["long"] as Double)
        val rightTop = LatLng(rt["lat"] as Double, rt["long"] as Double)
        val leftBottom = LatLng(lb["lat"] as Double, lb["long"] as Double)
        val rightBottom = LatLng(rb["lat"] as Double, rb["long"] as Double)
        val latLngBounds: LatLngBounds = LatLngBounds.Builder()
                .include(leftTop)
                .include(rightTop)
                .include(leftBottom)
                .include(rightBottom)
                .build()

        registrar.activity().runOnUiThread {
            mapboxMap?.easeCamera(CameraUpdateFactory.newLatLngBounds(latLngBounds, 50), 1000)
        }
        return true
    }
    return false
}

/**
 * Elküldi a Flutternek a térkép jelenlegi központi koordinátáját és a zoomlevelt
 */
fun MapboxMapController.getCoordinateAndZoom(): CoordinateModel? {
    val lat = mapboxMap?.cameraPosition?.target?.latitude ?: 0.0
    val long = mapboxMap?.cameraPosition?.target?.longitude ?: 0.0
    val zoom = mapboxMap?.cameraPosition?.zoom ?: 15.0
    return if (mapboxMap != null)
        CoordinateModel(lat,long,zoom)
    else
        null
}

/**
 * A telefon GPS-ének koordinátáira pozícionálja a térképet
 */
@SuppressLint("MissingPermission")
//IDE NÉZZ VISSZA
fun MapboxMapController.showCurrentPosition() {
    hasLocationPermission(registrar.activity()) {
        fusedLocationClient?.lastLocation?.addOnSuccessListener { location: Location? ->
            val position = CameraPosition.Builder()
                    .target(LatLng(location?.latitude ?: 47.0, location?.longitude ?: 19.0)) // Sets the new camera position
                    .zoom(17.0) // Sets the zoom
                    .build() // Creates a CameraPosition from the builder
            mapboxMap?.animateCamera(
                    CameraUpdateFactory
                            .newCameraPosition(position), 500
            )
            currentPosition = position.target
        }?.addOnCanceledListener {
            Log.wtf("fusedLocationClient  ", "cancel")
        }
        fusedLocationClient?.requestLocationUpdates(GMSLocationRequest, GMSLocationCallback, Looper.getMainLooper())
    }

}

/**
 * Elküldi a Flutternek a térkép jelenleg látható szélső koordinátáit, ezek hány méterre vannak a középponttól és milyen zoomlevel van rajta
 */
fun MapboxMapController.getCoordinateBounds(): LatLngBoundsNyomio? {
    val latLngBounds: LatLngBounds? = mapboxMap?.projection?.visibleRegion?.latLngBounds
    if (latLngBounds != null) {
        val zoom = mapboxMap?.cameraPosition?.zoom
        val bearing = mapboxMap?.cameraPosition?.bearing
        return if (mapboxMap != null && zoom != null && bearing != null) {
            val distanceToNorthEast = latLngBounds.center.distanceTo(latLngBounds.northEast)
            val distanceToSouthWest = latLngBounds.center.distanceTo(latLngBounds.southWest)
            LatLngBoundsNyomio(latLngBounds.center, zoom ?: 0.0, bearing ?: 0.0, distanceToNorthEast, distanceToSouthWest)
        } else
            null
    }
    else
        return null
}