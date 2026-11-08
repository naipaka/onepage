package com.naipaka.native_image_compressor

import kotlin.test.Test
import kotlin.test.assertEquals

class SampleSizeTest {
    @Test
    fun `keeps the full size when half would be smaller than the target`() {
        assertEquals(1, SampleSize.of(Size(4032, 3024), Size(2309, 1731)))
    }

    @Test
    fun `halves while both sides stay at least the target`() {
        assertEquals(2, SampleSize.of(Size(4032, 3024), Size(2016, 1512)))
        assertEquals(4, SampleSize.of(Size(8064, 6048), Size(2000, 1500)))
    }

    @Test
    fun `stops when one side would become smaller than the target`() {
        assertEquals(2, SampleSize.of(Size(9000, 3000), Size(3464, 1154)))
    }

    @Test
    fun `keeps the full size for an image that already fits`() {
        assertEquals(1, SampleSize.of(Size(1179, 2556), Size(1179, 2556)))
    }
}
