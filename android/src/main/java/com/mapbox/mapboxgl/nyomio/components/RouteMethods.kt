package com.mapbox.mapboxgl.nyomio.components

import android.animation.Animator
import android.animation.AnimatorListenerAdapter
import android.animation.ValueAnimator
import android.graphics.Color
import android.view.animation.LinearInterpolator
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.geojson.LineString
import com.mapbox.geojson.Point
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.animatedCoordinates
import com.mapbox.mapboxgl.nyomio.latLngAnimator
import com.mapbox.mapboxgl.nyomio.model.LatLngMapNyomio
import com.mapbox.mapboxgl.nyomio.route
import com.mapbox.mapboxgl.nyomio.routeIndex
import com.mapbox.mapboxsdk.style.layers.LineLayer
import com.mapbox.mapboxsdk.style.layers.Property
import com.mapbox.mapboxsdk.style.layers.PropertyFactory
import com.mapbox.mapboxsdk.style.sources.GeoJsonSource

/**
 * Útvonal animáció készítése
 */
fun MapboxMapController.createLatLngAnimator(currentPosition: Point, targetPosition: Point): Animator? {
    latLngAnimator = ValueAnimator.ofObject(PointEvaluator(), currentPosition, targetPosition)
    latLngAnimator?.setDuration(200L)
    latLngAnimator?.setInterpolator(LinearInterpolator())
    latLngAnimator?.addListener(object : AnimatorListenerAdapter() {
        override fun onAnimationEnd(animation: Animator?) {
            super.onAnimationEnd(animation)
            animateLine()
        }
    })
    latLngAnimator?.addUpdateListener { animation ->
        val point = animation.getAnimatedValue() as Point
        if (animatedCoordinates.size > 0) {
            animatedCoordinates.add(Point.fromLngLat(((point.longitude() + animatedCoordinates.last().longitude()) / 2.0), ((point.latitude() + animatedCoordinates.last().latitude()) / 2.0)))
        } else
            animatedCoordinates.add(point)
        val lineSource = mapboxMap?.style?.sources?.firstOrNull { it.id == LINE_SOURCE }
        if (mapboxMap?.style?.sources != null && lineSource != null) {
            var lineLayer = mapboxMap?.style?.layers?.firstOrNull { it.id == LINE_LAYER }
            if (lineLayer != null) {
                mapboxMap?.style?.removeLayer(lineLayer)
            }
            mapboxMap?.style?.removeSource(lineSource).let {
                if (it == true) {
                    mapboxMap?.style?.addSource(GeoJsonSource(LINE_SOURCE, FeatureCollection.fromFeatures(arrayOf(Feature.fromGeometry(LineString.fromLngLats(animatedCoordinates))))))
                    lineLayer = mapboxMap?.style?.layers?.firstOrNull { it.id == LINE_LAYER }
                    if (lineLayer == null) {
                        mapboxMap?.style?.addLayer(LineLayer(LINE_LAYER, LINE_SOURCE).withProperties(
                                PropertyFactory.lineCap(Property.LINE_CAP_ROUND),
                                PropertyFactory.lineJoin(Property.LINE_JOIN_ROUND),
                                PropertyFactory.lineWidth(5f),
                                PropertyFactory.lineColor(Color.parseColor("#e55e5e"))
                        ));
                    }
                }
            }
        } else {
            mapboxMap?.style?.addSource(GeoJsonSource(LINE_SOURCE, FeatureCollection.fromFeatures(arrayOf(Feature.fromGeometry(LineString.fromLngLats(animatedCoordinates))))))
            var lineLayer = mapboxMap?.style?.layers?.firstOrNull { it.id == LINE_LAYER }
            if (lineLayer != null) {
                mapboxMap?.style?.removeLayer(lineLayer!!)
            }
            else {
                mapboxMap?.style?.addLayer(LineLayer(LINE_LAYER, LINE_SOURCE).withProperties(
                        PropertyFactory.lineCap(Property.LINE_CAP_ROUND),
                        PropertyFactory.lineJoin(Property.LINE_JOIN_ROUND),
                        PropertyFactory.lineWidth(5f),
                        PropertyFactory.lineColor(Color.parseColor("#e55e5e"))
                ));
            }
        }
    }
    return latLngAnimator
}

/**
 * Útvonal animálása
 */
public fun MapboxMapController.animateLine() {
    //IDE NÉZZ VISSZA
    latLngAnimator?.removeAllUpdateListeners()
    registrar.activity().runOnUiThread {
        var lineSource = mapboxMap?.style?.sources?.firstOrNull { it.id == LINE_SOURCE }
        if (lineSource == null) {
            lineSource = GeoJsonSource(LINE_SOURCE, FeatureCollection.fromFeatures(arrayOf(Feature.fromGeometry(LineString.fromLngLats(animatedCoordinates)))))
            mapboxMap?.style?.addSource(lineSource)
        }
        var lineLayer = mapboxMap?.style?.layers?.firstOrNull { it.id == LINE_LAYER }
        if (lineLayer == null) {
            mapboxMap?.style?.addLayer(LineLayer(LINE_LAYER, LINE_SOURCE).withProperties(
                    PropertyFactory.lineCap(Property.LINE_CAP_ROUND),
                    PropertyFactory.lineJoin(Property.LINE_JOIN_ROUND),
                    PropertyFactory.lineWidth(5f),
                    PropertyFactory.lineColor(Color.parseColor("#e55e5e"))
            ));
        }
        if(animatedCoordinates != null) {
            if (((animatedCoordinates?.size ?: 0) - 1 > routeIndex)) {
                val indexPoint = animatedCoordinates?.get(routeIndex) ?: Point.fromLngLat(0.0, 0.0)
                val newPoint = Point.fromLngLat(indexPoint.longitude(), indexPoint.latitude());
                val currentAnimator = createLatLngAnimator(indexPoint, newPoint);
                currentAnimator?.start();
                routeIndex++;
            } else {
                animatedCoordinates = mutableListOf()
                routeIndex = 0
                val indexPoint = animatedCoordinates?.get(routeIndex)
                        ?: Point.fromLngLat(0.0, 0.0)
                val newPoint = Point.fromLngLat(indexPoint.longitude(), indexPoint.latitude());
                val currentAnimator = createLatLngAnimator(indexPoint, newPoint);
                currentAnimator?.start();
            }
        }
    }

}

/**
 * Útvonal rajzolás indítása
 */
public fun MapboxMapController.drawRoute(list: String) {
    routeIndex = 0
    animatedCoordinates = mutableListOf()
    route = Gson().fromJson(list,object : TypeToken<List<LatLngMapNyomio>>(){}.type)
    val coords = mutableListOf<Point>()
    route.sortedBy { it.order }.forEach {
        coords.add(Point.fromLngLat(it.long, it.lat))
    }
    animatedCoordinates = coords
    animateLine()
}