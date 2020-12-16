package com.mapbox.mapboxgl.nyomio.components

import android.util.Log
import com.google.gson.Gson
import com.google.gson.internal.LinkedTreeMap
import com.mapbox.geojson.Feature
import com.mapbox.mapboxgl.Convert
import com.mapbox.mapboxgl.MapboxMapController
import com.mapbox.mapboxgl.SymbolBuilder
import com.mapbox.mapboxgl.SymbolController
import com.mapbox.mapboxgl.nyomio.model.*
import com.mapbox.mapboxsdk.geometry.LatLng
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

import com.mapbox.mapboxsdk.plugins.annotation.Symbol

import com.mapbox.mapboxsdk.plugins.annotation.SymbolManager

import com.mapbox.mapboxsdk.plugins.annotation.SymbolOptions

fun Any.toJson() : String {
    return Gson().toJson(this)
}

/**
 * Methodchannelen értesíti a Fluttert, hogy inicializálva van a térkép
 */
fun MapboxMapController.mapInited(){
    methodChannel?.invokeMethod("nyomio#mapInit", "finished" /*Gson().toJson(data)*/)
}

/**
 * Methodchannelen értesíti a Fluttert, ha egy annotationre/markerre hosszan kattintottak
 */
fun MapboxMapController.markerLongClick(featureList: List<Feature>){
    methodChannel?.invokeMethod("nyomio#mapMarkerLongClick", (featureList.first().getStringProperty(PROPERTY_ID)
            ?: "0").toInt())
}

/**
 * Methodchannelen értesíti a Fluttert, ha egy alert annotationre/markerre hosszan kattintottak
 */
fun MapboxMapController.alertLongClick(featureList: List<Feature>){
    methodChannel?.invokeMethod("nyomio#mapAlertLongClick", (featureList.first().getStringProperty(PROPERTY_ID)
            ?: "0").toInt())
}

/**
 * Methodchannelen értesíti a Fluttert, ha a térképre hosszan kattintottak
 */
fun MapboxMapController.mapLongClick(it: LatLng){
    this.methodChannel?.invokeMethod("nyomio#mapLongClick", Gson().toJson(LatLng(it.latitude, it.longitude)))
}

/**
 * Methodchannelen értesíti a Fluttert, ha egy annotationre/markerre egyszer rákattintottak
 */
fun MapboxMapController.markerClick(featureList: List<Feature>){
    methodChannel?.invokeMethod("nyomio#mapMarkerClick", (featureList.first().getStringProperty(PROPERTY_ID)
            ?: "0").toInt())
}

/**
 * Methodchannelen értesíti a Fluttert, ha egy alert annotationre/markerre egyszer rákattintottak
 */
fun MapboxMapController.alertClick(featureList: List<Feature>){
    methodChannel?.invokeMethod("nyomio#mapAlertClick", (featureList.first().getStringProperty(PROPERTY_ID)
            ?: "0").toInt())
}

/**
 * Methodchannelen értesíti a Fluttert, ha a térképre egyszer rákattintottak
 */
fun MapboxMapController.mapClick(it: LatLng){
    methodChannel?.invokeMethod("nyomio#mapClick", Gson().toJson(LatLng(it.latitude, it.longitude)))
}

fun MapboxMapController.handleNyomioRequests(call: MethodCall, result: MethodChannel.Result){
    when(call.method) {
        /**
         * MAP METHODS *************************************************************************
         */
       /* "setUserLocationVisible" -> {
            application?.mapController?.setUserLocationVisible((call.arguments as? Boolean) ?: true)
            result.success(call.method + " success")
        }
        "setUserImage" -> {
            application?.mapController?.setUserLocationImage(call.arguments as String)
            result.success(call.method + " success")
        }*/
        "setCompassVisible" -> {
            setCompassVisible((call.arguments as? Boolean) ?: true)
            result.success(call.method + " success")
        }
        "setMapStyle" -> {
            setMapStyle(call.arguments.toString())
            result.success(call.method + " success")
        }
        /**
         * TRACKER METHODS *********************************************************************
         */
        "tracker#addAll" -> {
        val newSymbolIds = mutableListOf<String>()
        val options = call.argument("options") as? List<Object>
        var symbolOptionsList = mutableListOf<SymbolOptions>();
        if (options != null) {
          var symbolBuilder: SymbolBuilder? = null
            options.forEach {
                symbolBuilder = SymbolBuilder()
                Convert.interpretSymbolOptions(it, symbolBuilder);
                symbolOptionsList.add(symbolBuilder!!.symbolOptions);
            }

          if (!symbolOptionsList.isEmpty()) {
            var newSymbols = symbolManager.create(symbolOptionsList);
            var symbolId = ""
              newSymbols.forEach { symbol ->
                  symbolId = symbol.id.toString()
                  newSymbolIds.add(symbolId);
                  symbols[symbolId] = SymbolController(symbol, true, this);
              }
          }
        }
        result.success(newSymbolIds);
      }
       "tracker#removeAll" -> {
        var symbolIds = call.argument("symbols") as? ArrayList<String>
        var symbolController: SymbolController? = null
        var symbolList = mutableListOf<Symbol>();
           symbolIds?.forEach { symbolId ->
               symbolController = symbols.remove(symbolId);
               if (symbolController != null) {
                   symbolList.add(symbolController!!.symbol);
               }
           }
        if(symbolList.isNotEmpty()) {
          symbolManager.delete(symbolList);
        }
        result.success(null);
      }
        "tracker#update" -> {
        var symbolId = call.argument("symbol") as? String
        var symbol = symbol(symbolId);
        Convert.interpretSymbolOptions(call.argument("options"), symbol);
        symbol.update(symbolManager);
        result.success(null);
      }
       "tracker#getGeometry" -> {
        var symbolId = call.argument("symbol") as? String
        var symbol = symbol(symbolId);
        var symbolLatLng = symbol.geometry;
        var hashMapLatLng = hashMapOf<String, Double>()
           hashMapLatLng["latitude"] = symbolLatLng.latitude;
           hashMapLatLng["longitude"] = symbolLatLng.longitude;
        result.success(hashMapLatLng);
      }

        "addTracker" -> {
            val trackers = parseTrackersList(call.arguments)
            if (!trackers.isNullOrEmpty()) {
                addTracker(trackers.first())
                result.success(call.method + " success")
            } else
                result.error("100", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
        }

        "addTrackers" -> {
            val trackers = parseTrackersList(call.arguments)
            if (addTrackers(trackers) == true)
                result.success(call.method + " success")
            else
                result.error("101", "${call.method} ERROR", "DECODING ERROR OR LIST IS EMPTY OR MISSING ARGUMENT -> " + call.arguments.toString())
        }

        "updateTracker" -> {
            val trackers = parseTrackersList(call.arguments)
            if (!trackers.isNullOrEmpty()) {
                if (updateTracker(trackers.first()) == true)
                    result.success(call.method + " success")
                else
                    result.error("102", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
            } else
                result.error("102", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
        }

        "deleteTracker" -> {
            val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(call.arguments.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
            if (l != null && l.isNotEmpty()) {
                if ((l[0]["id"] as? Double) != null) {
                    val id = (l[0]["id"] as Double).toInt()
                    removeTracker(id)
                    result.success(call.method + " success")
                } else
                    result.error("103", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())

            } else
                result.error("103", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
        }

        /**
         * CAMERA METHODS **********************************************************************
         */
        "showCurrentPosition" -> {
            showCurrentPosition()
            result.success(call.method + " success")
        }

        "zoomToCoordinateBound" -> {
            if (zoomToCoordinateBounds(call.arguments) == true)
                result.success(call.method + " success")
            else
                result.error("201", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
        }

        "zoomToCoordinate" -> {
            if (zoomToCoordinate(call.arguments) == true)
                result.success(call.method + " success")
            else
                result.error("202", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())

        }
        "getCoordinateAndZoom" -> {
            getCoordinateAndZoom()?.let {
                result.success(it.toJson())
            } ?: run {
                result.error("203", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
            }
        }

        "getCoordinateBounds" -> {
            getCoordinateBounds()?.let {
                result.success(it.toJson())
            } ?: run {
                result.error("204", "${call.method} ERROR", "DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString())
            }
        }
        /**
         * PLACE METHODS ***********************************************************************
         */
        "addPlace" -> {
            val list = parsePlacesList(call.arguments)
            if (!list.isNullOrEmpty()) {
                registrar.activity()?.runOnUiThread {
                    addPlace(PlaceModel(list.first().id, list.first().name, list.first().center, list.first().latlongs, list.first().color))
                }
                result.success(call.method + " success")
            } else
                result.error("301", "${call.method} ERROR", "DECODING ERROR OR PLACE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())

        }
        "addPlaces" -> {
            val list = parsePlacesList(call.arguments)
            if (!list.isNullOrEmpty()) {
                registrar.activity()?.runOnUiThread {
                    addPlaces(list)
                }
                result.success(call.method + " success")
            } else
                result.error("302", "${call.method} ERROR", "DECODING ERROR OR LIST IS EMPTY OR MISSING ARGUMENT -> " + call.arguments.toString())

            result.success(call.method + " success")
        }
        "deletePlace" -> {
            val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(call.arguments.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
            Log.wtf("deletePlace", l.toString())
            if (l != null && l.isNotEmpty()) {
                val id = (l[0]["id"] as? Double)?.toInt() ?: -1
                if (id != -1) {
                    removePolygon(id)
                    result.success(call.method + " success")
                } else {
                    result.error("303", "${call.method} ERROR", "DECODING ERROR OR PLACE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())
                }
            } else
                result.error("303", "${call.method} ERROR", "DECODING ERROR OR PLACE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())
        }
        /**
         * ROUTE METHODS ***********************************************************************
         */
        "drawRoute" -> {
            print(call.arguments)
            val list = mutableListOf<LatLngMapNyomio>()
            val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(call.arguments.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
            l.forEach { c ->
                if ((c["order"] as? Double) != null && (c["lat"] as? Double) != null && (c["long"] as? Double) != null)
                    list.add(LatLngMapNyomio((c["order"] as Double).toInt(), c["lat"] as Double, c["long"] as Double))
            }
            if (list.isNotEmpty()) {
                registrar.activity()?.runOnUiThread {
                    drawRoute(list.toJson())
                }
                result.success(call.method + " success")
            } else
                result.error("401", "${call.method} ERROR", "DECODING ERROR OR ROUTE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())

        }

        /**
         * NOT USED ****************************************************************************
         */
        "addPolygons" -> {
            print(call.arguments)
            //  addPolygons(Gson().fromJson<List<PolygonModel>>(call.arguments.toString(),typeToken<List<PolygonModel>>()))
            result.success(call.method + " success")

        }
        "addCircle" -> {
            print(call.arguments)
            //addCirclePlace(1.1,1.1,10.0,36)
            result.success(call.method + " success")

        }
        "addErrors" -> {
            print(call.arguments)
            // addAlerts(Gson().fromJson<List<ErrorModel>>(call.arguments.toString(),typeToken<List<ErrorModel>>()))
            result.success(call.method + " success")

        }
        /**
         *
         */


        else -> {
            result.notImplemented()
        }
    }
  /*   case "tracker#add": {
        List<TrackerModel> trackers = ParseKt.parseTrackersList(call.arguments);
        if (trackers != null && trackers.size() > 0) {
          TrackerMethodsKt.addTracker(this,trackers.get(0));
          result.success(call.method + " success");
        }
        else
          result.error("100","${call.method} ERROR","DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString());
        break;
      }
      case "tracker#addAll": {
        List<TrackerModel> trackers = ParseKt.parseTrackersList(call.arguments);
        if(TrackerMethodsKt.addTrackers(this,trackers) == true)
            result.success(call.method + " success");
        else
            result.error("101","${call.method} ERROR","DECODING ERROR OR LIST IS EMPTY OR MISSING ARGUMENT -> " + call.arguments.toString());
        break;
      }
      case "tracker#remove": {
        List<LinkedTreeMap<String,Object>> l = ParseKt.parseTracker(call.arguments);
        if (l != null && l.size() > 0) {
          if (((Double) l.get(0).get("id")) != null) {
            int id = ((Double) l.get(0).get("id")).intValue();
            TrackerMethodsKt.removeTracker(this,id);
            result.success(call.method + " success");
          }
                    else
                result.error("103","${call.method} ERROR","DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString() );
          break;
        }
        else
          result.error("103","${call.method} ERROR","DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments.toString() );
          break;
      }
      case "tracker#update": {
        List<TrackerModel> trackers = ParseKt.parseTrackersList(call.arguments);
        if (trackers != null && trackers.size() > 0) {
          TrackerMethodsKt.updateTracker(this,trackers.get(0));
          result.success(call.method + " success");
        }
        else
          result.error("102","${call.method} ERROR","DECODING ERROR OR MISSING ARGUMENT -> " + call.arguments);
        break;
      }
      *//*"addPlace" -> {
                val list = getPlacesList(call.arguments)
                if (!list.isNullOrEmpty()){
                    application?.mainActivity?.runOnUiThread {
                        addPlace(PlaceModel(list.first().id, list.first().name, list.first().center, list.first().latlongs, list.first().color))
                    }
                    result.success(call.method + " success")
                }
                else
                    result.error("301","${call.method} ERROR","DECODING ERROR OR PLACE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())

            }
            "addPlaces" -> {
                val list = getPlacesList(call.arguments)
                if (!list.isNullOrEmpty()){
                    application?.mainActivity?.runOnUiThread {
                        addPlaces(list)
                    }
                    result.success(call.method + " success")
                }
                else
                    result.error("302","${call.method} ERROR","DECODING ERROR OR LIST IS EMPTY OR MISSING ARGUMENT -> " + call.arguments.toString())

                result.success(call.method+" success")
            }
            "deletePlace" -> {
                val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(call.arguments.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
                Log.wtf("deletePlace", l.toString())
                if (l != null && l.isNotEmpty()) {
                    val id = (l[0]["id"] as? Double)?.toInt()?:-1
                    if (id != -1) {
                        removePolygon(id)
                        result.success(call.method + " success")
                    }
                    else {
                        result.error("303","${call.method} ERROR","DECODING ERROR OR PLACE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())
                    }
                }
                else
                    result.error("303","${call.method} ERROR","DECODING ERROR OR PLACE IS NULL OR MISSING ARGUMENT -> " + call.arguments.toString())
            }*/
}