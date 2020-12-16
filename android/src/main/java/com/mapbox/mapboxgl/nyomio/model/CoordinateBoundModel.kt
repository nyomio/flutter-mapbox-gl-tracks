package com.mapbox.mapboxgl.nyomio.model

class CoordinateBoundModel {
    var id: Int? = 0
    var name: String? = ""
    var latlong: LatLngMapNyomio = LatLngMapNyomio()
    var image: String? = null
    var color: String? = "#ffffff"

    constructor(id: Int? = 0, name: String? = "", latlong: LatLngMapNyomio = LatLngMapNyomio(), image: String? = "", color: String? = "") {
        this.id = id
        this.name = name
        this.latlong = latlong
        this.image = image
        this.color = color
    }
}

class LatLngMapNyomio {

    var order: Int = 0
    var lat: Double = 0.0
    var long: Double = 0.0

    constructor(order: Int = 0, lat: Double = 0.0, long: Double = 0.0) {
        this.order = order
        this.lat = lat
        this.long = long
    }
}
