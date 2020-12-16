package com.mapbox.mapboxgl.nyomio.model

import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.internal.LinkedTreeMap
import com.google.gson.reflect.TypeToken
import org.json.JSONException
import org.json.JSONObject
import java.lang.reflect.Type
import java.util.*
import kotlin.collections.ArrayList


fun <T> typeToken(): Type {
    return object : TypeToken<T>() {}.type
}

inline fun <reified T> parseArray(json: String, tt: Type): T {
    val gson = GsonBuilder().create()
    return gson.fromJson<T>(json, tt)
}

fun convertKeyValueToJSON(ltm: LinkedTreeMap<String?, Any?>): JSONObject? {
    val jo = JSONObject()
    val objs: Array<Any> = ltm.entries.toTypedArray()
    for (l in objs.indices) {
        val o = objs[l] as Map.Entry<*, *>
        try {
            if (o.value is LinkedTreeMap<*, *>) jo.put(o.key.toString(), convertKeyValueToJSON(o.value as LinkedTreeMap<String?, Any?>)) else jo.put(o.key.toString(), o.value)
        } catch (e: JSONException) {
            e.printStackTrace()
        }
    }
    return jo
}


fun parsePlacesList(places: Any?): MutableList<PlaceModel> {
    val list = mutableListOf<PlaceModel>()
    if (places == null)
        return list
    val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(places.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
    l.forEach {
        val id = (it["id"] as Double).toInt()
        val name = it["name"] as String
        val c = it["center"] as LinkedTreeMap<String, Any>
        val center = LatLngMapNyomio((c["order"] as Double).toInt(), c["lat"] as Double, c["long"] as Double)
        val lats = it["latlongs"] as ArrayList<LinkedTreeMap<String, Any>>
        val latlongs = mutableListOf<LatLngMapNyomio>()
        lats.forEach {
            latlongs.add(LatLngMapNyomio((it["order"] as Double).toInt(), it["lat"] as Double, it["long"] as Double))
        }
        val color = it["color"] as? String
        list.add(PlaceModel(id, name, center, latlongs, color))
    }
    return list
}

fun parseTrackersList(trackers: Any?): MutableList<TrackerModel>{
    val list = mutableListOf<TrackerModel>()
    if (trackers == null)
        return list
    val l = Gson().fromJson<List<LinkedTreeMap<String, Any>>>(trackers.toString(), typeToken<List<LinkedTreeMap<String, Any>>>())
    l.forEach {
        val id = (it["id"] as Double).toInt()
        val name = it["name"] as String
        val c = it["latlong"] as LinkedTreeMap<String, Any>
        val latlong = LatLngMapNyomio((c["order"] as Double).toInt(), c["lat"] as Double, c["long"] as Double)
        val image = it["image"] as String
        val color = it["color"] as String
        list.add(TrackerModel(id, name, latlong, image, color))
    }
    return list
}

fun parseTracker(arguments: Object): MutableList<LinkedTreeMap<String, Any>> {
    return Gson().fromJson<MutableList<LinkedTreeMap<String, Any>>>(arguments.toString(), typeToken<MutableList<LinkedTreeMap<String, Any>>>())
}
