package com.naipaka.native_image_compressor

import android.media.ExifInterface
import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

class OrientationTest {
    @Test
    fun `swaps the sides for quarter turns`() {
        for (value in listOf(
            ExifInterface.ORIENTATION_TRANSPOSE,
            ExifInterface.ORIENTATION_ROTATE_90,
            ExifInterface.ORIENTATION_TRANSVERSE,
            ExifInterface.ORIENTATION_ROTATE_270,
        )) {
            assertTrue(Orientation(value).swapsSides, "orientation $value")
        }
    }

    @Test
    fun `keeps the sides otherwise`() {
        for (value in listOf(
            ExifInterface.ORIENTATION_UNDEFINED,
            ExifInterface.ORIENTATION_NORMAL,
            ExifInterface.ORIENTATION_FLIP_HORIZONTAL,
            ExifInterface.ORIENTATION_ROTATE_180,
            ExifInterface.ORIENTATION_FLIP_VERTICAL,
        )) {
            assertFalse(Orientation(value).swapsSides, "orientation $value")
        }
    }
}
