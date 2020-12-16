package com.mapbox.mapboxgl.nyomio.components

import android.animation.TypeEvaluator
import com.mapbox.geojson.Point

/**
 * Az útvonalak két koordináta közötti animálására készített class
 */
class PointEvaluator : TypeEvaluator<Point?> {

    override fun evaluate(p0: Float, p1: Point?, p2: Point?): Point? {
        val startValue = p1 ?: Point.fromLngLat(0.0, 0.0)
        val endValue = p2 ?: Point.fromLngLat(0.0, 0.0)
        val fraction = p0 ?: 0F
        return Point.fromLngLat(
                startValue.longitude() + (endValue.longitude() - startValue.longitude()) * fraction,
                startValue.latitude() + (endValue.latitude() - startValue.latitude()) * fraction
        )
    }
}