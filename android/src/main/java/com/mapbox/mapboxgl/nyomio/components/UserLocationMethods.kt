package com.mapbox.mapboxgl.nyomio.components

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.model.LatLngMapNyomio
import com.mapbox.mapboxgl.nyomio.model.TrackerModel
import com.mapbox.mapboxsdk.location.LocationComponentActivationOptions


/**
 * A telefon tracker annotation megjelenítése a térképen
 */
/*fun MapboxMapController.setUserLocationVisible(visible: Boolean?) {
    hasLocationPermission(registrar.activity()) {
        viewModel?.userLocationIsVisible?.postValue(visible)
    }
}*/

/**
 * A telefon tracker annotation képének módosítása a térképen
 */
/*fun MapboxMapController.setUserLocationImage(image: String) {
    if (currentPosition != null) {
        if (!trackers.isNullOrEmpty()) {
            if (myTracker == null) {
                myTracker = TrackerModel(PHONE_AS_TRACKER_ID, PHONE_AS_TRACKER, LatLngMapNyomio(0, currentPosition!!.latitude, currentPosition!!.longitude), userAnnotationImage, "#ffffff")
                addTracker(myTracker)
            }

        } else {
            myTracker = TrackerModel(PHONE_AS_TRACKER_ID, PHONE_AS_TRACKER, LatLngMapNyomio(0, currentPosition!!.latitude, currentPosition!!.longitude), userAnnotationImage, "#ffffff")
            addTracker(myTracker)
        }
    }
    userAnnotationImage = image

}*/

/**
 * A térkép jelenlegi pozíció jelzőjének inicializálása
 */
/*@SuppressLint("MissingPermission")
fun MapboxMapController.setUpLocationComponent() {
    hasLocationPermission(registrar.activity()) {
        if (mapboxMap?.style != null && mapboxMap?.style?.isFullyLoaded == true) {
            mapboxMap?.locationComponent?.activateLocationComponent(LocationComponentActivationOptions.builder(registrar.activity(), mapboxMap?.style!!).useDefaultLocationEngine(true).build())
            mapboxMap?.locationComponent?.isLocationComponentEnabled = true
        }
    }

}*/
/**
 * Helymeghatározási engedélyek ellenőrzáse
 */
fun hasLocationPermission(activity: Activity, onSuccess: (Boolean) -> Unit){
    onSuccess(ActivityCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED)
}