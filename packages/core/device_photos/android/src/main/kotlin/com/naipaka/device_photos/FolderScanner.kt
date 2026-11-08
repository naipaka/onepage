package com.naipaka.device_photos

/** A file or directory in a folder. */
internal data class FolderEntry(
    val documentId: String,
    val isDirectory: Boolean,
    val isImage: Boolean,
)

/** Reads the contents of a folder the user selected. */
internal interface DocumentTree {
    /** Returns the entries directly inside the directory [documentId]. */
    fun children(documentId: String): List<FolderEntry>

    /** Returns the media ID of the document [documentId], or null if it has none. */
    fun mediaId(documentId: String): String?
}

/** Finds the documents in a folder that match media IDs. */
internal class FolderScanner(private val tree: DocumentTree) {
    /** Returns the document IDs under [rootId] that match [ids], keyed by media ID. */
    fun find(rootId: String, ids: Set<String>): Map<String, String> {
        val found = mutableMapOf<String, String>()
        val directories = ArrayDeque(listOf(rootId))
        while (directories.isNotEmpty() && found.size < ids.size) {
            for (entry in tree.children(directories.removeFirst())) {
                when {
                    entry.isDirectory -> directories.addLast(entry.documentId)
                    entry.isImage -> {
                        val id = tree.mediaId(entry.documentId)
                        if (id in ids) {
                            found[id!!] = entry.documentId
                        }
                    }
                }
            }
        }
        return found
    }
}
