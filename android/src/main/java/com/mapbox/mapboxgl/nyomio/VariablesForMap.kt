package com.mapbox.mapboxgl.nyomio

import android.animation.ValueAnimator
import com.google.android.gms.location.FusedLocationProviderClient
import com.mapbox.geojson.Feature
import com.mapbox.geojson.FeatureCollection
import com.mapbox.geojson.Point
import com.mapbox.mapboxgl.nyomio.model.LatLngMapNyomio
import com.mapbox.mapboxgl.nyomio.model.PlaceModel
import com.mapbox.mapboxgl.nyomio.model.TrackerModel
import com.mapbox.mapboxsdk.annotations.Polygon
import com.mapbox.mapboxsdk.geometry.LatLng

/**
 * NYOMIO *********************************
 */
var routeIndex = 0
var animatedCoordinates: MutableList<Point> = mutableListOf()
var latLngAnimator: ValueAnimator? = null
var route: MutableList<LatLngMapNyomio> = mutableListOf()
var features: MutableList<Feature> = mutableListOf()
var trackers: MutableList<TrackerModel> = mutableListOf()
var isTrackerRemove = false
var featureCollection: FeatureCollection? = null
var places: MutableList<PlaceModel> = mutableListOf()
var polygons: MutableList<Polygon> = mutableListOf()
var fusedLocationClient: FusedLocationProviderClient? = null
var currentPosition: LatLng? = null
/**
 * ****************************************
 */