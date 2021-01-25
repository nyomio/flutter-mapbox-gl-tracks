package com.mapbox.mapboxgl.nyomio.model

import com.google.gson.Gson

class CoordinateModel {
    var lat: Double = 0.0
    var long: Double = 0.0
    var zoom: Double = 0.0

    constructor(lat: Double, long: Double, zoom: Double) {
        this.lat = lat
        this.long = long
        this.zoom = zoom
    }
    fun toJson(): String{
       return Gson().toJson(this)
    }
}
