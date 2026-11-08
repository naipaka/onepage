package com.naipaka.native_image_compressor

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.media.ExifInterface
import android.os.Build
import java.io.ByteArrayOutputStream

internal data class Size(val width: Int, val height: Int)

internal enum class OutputFormat(val compressFormat: Bitmap.CompressFormat) {
    JPEG(Bitmap.CompressFormat.JPEG),
    PNG(Bitmap.CompressFormat.PNG),
}

internal object ImageCompressor {
    private const val MAX_RETRIES = 3

    /** Returns the size of the image at [path] after its orientation is applied. */
    fun size(path: String): Size {
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        if (bounds.outWidth <= 0 || bounds.outHeight <= 0) {
            throw IllegalArgumentException("Cannot read the image at $path")
        }
        val size = Size(bounds.outWidth, bounds.outHeight)
        return if (Orientation.read(path).swapsSides) Size(size.height, size.width) else size
    }

    fun compress(path: String, width: Int, height: Int, format: OutputFormat, quality: Int): ByteArray {
        val bitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            ImageDecoderReader.read(path, Size(width, height))
        } else {
            readWithBitmapFactory(path, Size(width, height))
        }
        try {
            val output = ByteArrayOutputStream()
            if (!bitmap.compress(format.compressFormat, quality, output)) {
                throw IllegalStateException("Cannot write the image at $path")
            }
            return output.toByteArray()
        } finally {
            bitmap.recycle()
        }
    }

    private fun readWithBitmapFactory(path: String, target: Size): Bitmap {
        val orientation = Orientation.read(path)
        val encodedTarget = if (orientation.swapsSides) Size(target.height, target.width) else target
        val bounds = BitmapFactory.Options().apply { inJustDecodeBounds = true }
        BitmapFactory.decodeFile(path, bounds)
        var sampleSize = SampleSize.of(Size(bounds.outWidth, bounds.outHeight), encodedTarget)
        var retries = 0
        while (true) {
            try {
                val decoded = BitmapFactory.decodeFile(path, BitmapFactory.Options().apply { inSampleSize = sampleSize })
                    ?: throw IllegalArgumentException("Cannot read the image at $path")
                return transform(decoded, encodedTarget, orientation)
            } catch (e: OutOfMemoryError) {
                if (retries == MAX_RETRIES) {
                    throw e
                }
                retries++
                sampleSize *= 2
            }
        }
    }

    private fun transform(bitmap: Bitmap, encodedTarget: Size, orientation: Orientation): Bitmap {
        val matrix = Matrix()
        val scale = minOf(
            1f,
            encodedTarget.width.toFloat() / bitmap.width,
            encodedTarget.height.toFloat() / bitmap.height,
        )
        if (scale < 1f) {
            matrix.postScale(scale, scale)
        }
        orientation.applyTo(matrix)
        if (matrix.isIdentity) {
            return bitmap
        }
        val transformed = Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
        if (transformed !== bitmap) {
            bitmap.recycle()
        }
        return transformed
    }
}

internal class Orientation(private val value: Int) {
    val swapsSides: Boolean
        get() = value in setOf(
            ExifInterface.ORIENTATION_TRANSPOSE,
            ExifInterface.ORIENTATION_ROTATE_90,
            ExifInterface.ORIENTATION_TRANSVERSE,
            ExifInterface.ORIENTATION_ROTATE_270,
        )

    fun applyTo(matrix: Matrix) {
        when (value) {
            ExifInterface.ORIENTATION_FLIP_HORIZONTAL -> matrix.postScale(-1f, 1f)
            ExifInterface.ORIENTATION_ROTATE_180 -> matrix.postRotate(180f)
            ExifInterface.ORIENTATION_FLIP_VERTICAL -> matrix.postScale(1f, -1f)
            ExifInterface.ORIENTATION_TRANSPOSE -> {
                matrix.postRotate(90f)
                matrix.postScale(-1f, 1f)
            }
            ExifInterface.ORIENTATION_ROTATE_90 -> matrix.postRotate(90f)
            ExifInterface.ORIENTATION_TRANSVERSE -> {
                matrix.postRotate(-90f)
                matrix.postScale(-1f, 1f)
            }
            ExifInterface.ORIENTATION_ROTATE_270 -> matrix.postRotate(-90f)
        }
    }

    companion object {
        /** Returns the normal orientation when the file has no readable EXIF data. */
        fun read(path: String): Orientation = try {
            Orientation(
                ExifInterface(path).getAttributeInt(
                    ExifInterface.TAG_ORIENTATION,
                    ExifInterface.ORIENTATION_NORMAL,
                ),
            )
        } catch (e: Exception) {
            Orientation(ExifInterface.ORIENTATION_NORMAL)
        }
    }
}

internal object SampleSize {
    /**
     * Returns the largest power of two that shrinks [source] without making
     * either side smaller than [target].
     */
    fun of(source: Size, target: Size): Int {
        var sampleSize = 1
        while (
            source.width / (sampleSize * 2) >= target.width &&
            source.height / (sampleSize * 2) >= target.height
        ) {
            sampleSize *= 2
        }
        return sampleSize
    }
}
