package com.mapbox.mapboxgl.nyomio.model

import com.google.gson.Gson
import com.mapbox.mapboxsdk.geometry.LatLng

data class LatLngBoundsNyomio (
        val center: LatLng,
        val zoom: Double,
        val bearing: Double,
        val distanceToNorthEast: Double,
        val distanceToSouthWest: Double
) {
    fun toJson(): String {
        return Gson().toJson(this)
    }
}