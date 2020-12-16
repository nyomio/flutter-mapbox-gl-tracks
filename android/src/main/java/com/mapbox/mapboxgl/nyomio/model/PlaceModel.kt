package com.mapbox.mapboxgl.nyomio.model

class PlaceModel {
        var id: Int = 0
        var name: String = ""
        var center: LatLngMapNyomio = LatLngMapNyomio()
        var latlongs: MutableList<LatLngMapNyomio> = mutableListOf()
        var color: String? = "#990000ff"

        constructor(id: Int, name: String, center: LatLngMapNyomio, latlongs: MutableList<LatLngMapNyomio>, color: String?) {
                this.id = id
                this.name = name
                this.center = center
                this.latlongs = latlongs
                this.color = color
        }
}
