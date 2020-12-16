package com.mapbox.mapboxgl.nyomio.model


data class PolygonModel (
        val id: Long,
        val positions: MutableList<LatLngMapNyomio> = mutableListOf(),
        val color: String? = "#00ff00",
        val alpha: Float = 0.2f
)
