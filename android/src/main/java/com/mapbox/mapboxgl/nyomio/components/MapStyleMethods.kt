package com.mapbox.mapboxgl.nyomio.components

import android.util.Log
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.nyomio.features
import com.mapbox.mapboxgl.nyomio.places
import com.mapbox.mapboxgl.nyomio.trackers
import com.mapbox.mapboxsdk.maps.Style

/**
 * Iránytű láthatóságának állítása
 */
fun MapboxMapController.setCompassVisible(visible: Boolean?) {
    mapboxMap?.uiSettings?.setCompassFadeFacingNorth(true)
    mapboxMap?.uiSettings?.isCompassEnabled = visible ?: true
}

/**
 * A térkép stílusának beállítása
 * Miután stílust vált a Mapbox újra fel kell vennünk a placeket és a trackereket
 */
fun MapboxMapController.setMapStyle(style: String?) {
    features = arrayListOf()
    when (style) {
        "dark" -> {
            mapboxMap?.setStyle(Style.DARK).let {
                addPlaces(places)
                addTrackers(trackers)
            }
            return
        }
        "satellite" -> {
            mapboxMap?.setStyle(Style.SATELLITE).let {
                addPlaces(places)
                addTrackers(trackers)
            }
            return
        }
        "light" -> {
            mapboxMap?.setStyle(Style.LIGHT).let {
                addPlaces(places)
                addTrackers(trackers)
            }
            return
        }
        "outdoor" -> {
            mapboxMap?.setStyle(Style.OUTDOORS).let {
                addPlaces(places)
                addTrackers(trackers)
            }
            return
        }
        "street" -> {
            mapboxMap?.setStyle(Style.MAPBOX_STREETS).let {
                addPlaces(places)
                addTrackers(trackers)
            }

            return
        }
        else -> {
            Log.e("setMapStyle error ", style ?: "")
            return
        }
    }


}
