package com.naipaka.device_photos

import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

internal class FolderScannerTest {
    private class FakeTree(
        private val entries: Map<String, List<FolderEntry>>,
        private val mediaIds: Map<String, String>,
    ) : DocumentTree {
        val visited = mutableListOf<String>()
        val looked = mutableListOf<String>()

        override fun children(documentId: String): List<FolderEntry> {
            visited.add(documentId)
            return entries[documentId].orEmpty()
        }

        override fun mediaId(documentId: String): String? {
            looked.add(documentId)
            return mediaIds[documentId]
        }
    }

    private fun image(id: String) = FolderEntry(id, isDirectory = false, isImage = true)

    private fun directory(id: String) = FolderEntry(id, isDirectory = true, isImage = false)

    @Test
    fun findsMatchingImagesInSubfolders() {
        val tree = FakeTree(
            entries = mapOf(
                "root" to listOf(image("a"), directory("sub")),
                "sub" to listOf(directory("deep")),
                "deep" to listOf(image("b")),
            ),
            mediaIds = mapOf("a" to "1", "b" to "2"),
        )

        val found = FolderScanner(tree).find("root", setOf("1", "2"))

        assertEquals(mapOf("1" to "a", "2" to "b"), found)
    }

    @Test
    fun ignoresImagesThatDoNotMatch() {
        val tree = FakeTree(
            entries = mapOf("root" to listOf(image("a"), image("b"))),
            mediaIds = mapOf("a" to "1"),
        )

        val found = FolderScanner(tree).find("root", setOf("9"))

        assertTrue(found.isEmpty())
    }

    @Test
    fun skipsFilesThatAreNotImages() {
        val video = FolderEntry("video", isDirectory = false, isImage = false)
        val tree = FakeTree(
            entries = mapOf("root" to listOf(video)),
            mediaIds = mapOf("video" to "1"),
        )

        val found = FolderScanner(tree).find("root", setOf("1"))

        assertTrue(found.isEmpty())
        assertTrue(tree.looked.isEmpty())
    }

    @Test
    fun stopsScanningOnceEveryIdIsFound() {
        val tree = FakeTree(
            entries = mapOf(
                "root" to listOf(image("a"), directory("sub")),
                "sub" to listOf(image("b")),
            ),
            mediaIds = mapOf("a" to "1", "b" to "2"),
        )

        val found = FolderScanner(tree).find("root", setOf("1"))

        assertEquals(mapOf("1" to "a"), found)
        assertEquals(listOf("root"), tree.visited)
    }

    @Test
    fun readsNothingWithoutIds() {
        val tree = FakeTree(entries = emptyMap(), mediaIds = emptyMap())

        assertTrue(FolderScanner(tree).find("root", emptySet()).isEmpty())
        assertTrue(tree.visited.isEmpty())
    }
}
