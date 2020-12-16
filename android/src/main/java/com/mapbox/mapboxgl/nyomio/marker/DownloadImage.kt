package com.mapbox.mapboxgl.nyomio.marker

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import coil.ImageLoader
import coil.request.ImageRequest
import com.mapbox.mapboxgl.MapboxMapController
import java.util.concurrent.Executors

/**
 * Kép letöltése internetről
 */
fun MapboxMapController.downloadImage(context: Context, name: String, url: String?, showImage: (Bitmap?) -> (Unit)) {

    /*Executors.newSingleThreadExecutor().execute {
        require(url != null)
        {
            "Az url nem lehet null"
        }

        var bitmap: Bitmap? = null
        val request = ImageRequest.Builder(context)
                .data(url)
                .target(onSuccess = {
                    bitmap = drawableToBitmap(it)
                    if (bitmap != null) {
                        saveToInternalStorage(context, bitmap!!, name)
                        showImage(bitmap)
                    }
                }, onError = {
                    showImage(loadImageFromStorage(context, name))
                })
                .build()
        ImageLoader(context).enqueue(request)
    }*/
}

/**
 * A képletöltés Drawable-t ad vissza, viszont a térképre nekünk Bitmap kell, így átalakítjuk Bitmappá
 */
fun drawableToBitmap(drawable: Drawable): Bitmap? {
    var bitmap: Bitmap? = null
    if (drawable is BitmapDrawable) {
        val bitmapDrawable = drawable
        if (bitmapDrawable.bitmap != null) {
            return bitmapDrawable.bitmap
        }
    }
    bitmap = if (drawable.intrinsicWidth <= 0 || drawable.intrinsicHeight <= 0) {
        Bitmap.createBitmap(1, 1, Bitmap.Config.ARGB_8888) // Single color bitmap will be created of 1x1 pixel
    } else {
        Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
    }
    val canvas = Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight())
    drawable.draw(canvas)
    return bitmap
}