package com.naipaka.native_image_compressor

import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.os.Build
import androidx.annotation.RequiresApi
import java.io.File

/** [ImageDecoder] applies the EXIF orientation itself. */
@RequiresApi(Build.VERSION_CODES.P)
internal object ImageDecoderReader {
    fun read(path: String, target: Size): Bitmap {
        val source = ImageDecoder.createSource(File(path))
        return ImageDecoder.decodeBitmap(source) { decoder, info, _ ->
            if (info.size.width > target.width || info.size.height > target.height) {
                decoder.setTargetSize(target.width, target.height)
            }
            decoder.allocator = ImageDecoder.ALLOCATOR_SOFTWARE
        }
    }
}
