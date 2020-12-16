package com.mapbox.mapboxgl.nyomio.components

import android.annotation.SuppressLint
import com.google.android.gms.location.LocationAvailability
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.currentPosition
import com.mapbox.mapboxsdk.geometry.LatLng

val MapboxMapController.GMSLocationRequest
get() = LocationRequest.create().setInterval(1000).setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY).setMaxWaitTime(2000)

/**
 * Telefon tracker pozíciójának módosítása a térképen a telefon GPS koordinátái alapján
 */
val MapboxMapController.GMSLocationCallback
get() = object : LocationCallback() {
    @SuppressLint("MissingPermission")
    override fun onLocationResult(p0: LocationResult?) {
        super.onLocationResult(p0)
        if (p0 != null && p0.lastLocation != null) {
            currentPosition = LatLng(p0!!.lastLocation!!.latitude, p0!!.lastLocation!!.longitude)
        }
    }

    override fun onLocationAvailability(p0: LocationAvailability?) {
        super.onLocationAvailability(p0)
    }
}