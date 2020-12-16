package com.mapbox.mapboxgl.nyomio.marker

import android.content.Context
import android.content.ContextWrapper
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.*

/**
 * A trackerek képeit elmentjük a telefon háttértárába, hogy offline is látszódjon
 */
fun saveToInternalStorage( context: Context, bitmapImage: Bitmap, name: String): String? {
    // Create imageDir
    val mypath = File(ContextWrapper(context).getDir("nyomio_images", Context.MODE_PRIVATE), name)
    var fos: FileOutputStream? = null
    try {
        fos = FileOutputStream(mypath)
        // Use the compress method on the BitMap object to write image to the OutputStream
        bitmapImage.compress(Bitmap.CompressFormat.PNG, 100, fos)
    } catch (e: Exception) {
        e.printStackTrace()
    } finally {
        try {
            fos!!.close()
        } catch (e: IOException) {
            e.printStackTrace()
        }
    }
    return ContextWrapper(context).getDir("nyomio_images", Context.MODE_PRIVATE)?.absolutePath
}

/**
 * A trackerek képeit ezzel kérjük el a telefon háttértárából közül
 */
fun loadImageFromStorage(context: Context, name: String, color: String = "#ffffff", size: Int = 2): Bitmap? {
    return try {
        val f = File(ContextWrapper(context).getDir("nyomio_images", Context.MODE_PRIVATE), name)
        val b: Bitmap? = BitmapFactory.decodeStream(FileInputStream(f))
        getRoundedCornerBitmapWithBorder(b,color,size)
    } catch (e: FileNotFoundException) {
        e.printStackTrace()
        null
    }
}