package com.mapbox.mapboxgl.nyomio.marker

import android.graphics.*

/**
 * A tracker képét vágja körbe és illeszti rá a groupnak megfelelő bordert
 */
fun getRoundedCornerBitmapWithBorder(bitmap: Bitmap?, borderColor: String = "#FFFFFF", borderSize: Int = 6): Bitmap? {
    if ( bitmap == null )
        return null
    val resized = Bitmap.createScaledBitmap(bitmap,150, 150, true);

    val w: Int = resized.width
    val h: Int = resized.height

    val radius = Math.min(h / 2, w / 2)
    val output = Bitmap.createBitmap(w + 8, h + 8, Bitmap.Config.ARGB_8888)

    val p = Paint()
    p.isAntiAlias = true

    val c = Canvas(output)
    c.drawARGB(0, 0, 0, 0)
    p.style = Paint.Style.FILL

    c.drawCircle((w / 2 + 4).toFloat(), (h / 2 + 4).toFloat(), radius.toFloat(), p)

    p.xfermode = PorterDuffXfermode(PorterDuff.Mode.SRC_IN)

    c.drawBitmap(resized, 4f, 4f, p)
    p.xfermode = null
    p.style = Paint.Style.STROKE
    p.color = Color.parseColor(borderColor)
    p.setStrokeWidth(borderSize.toFloat())
    c.drawCircle((w / 2 + 4).toFloat(), (h / 2 + 4).toFloat(), radius.toFloat(), p)

    return output
}
