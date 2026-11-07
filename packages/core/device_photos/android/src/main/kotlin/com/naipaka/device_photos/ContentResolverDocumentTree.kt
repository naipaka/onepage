package com.naipaka.device_photos

import android.content.Context
import android.net.Uri
import android.os.Build
import android.provider.DocumentsContract
import android.provider.MediaStore
import androidx.annotation.RequiresApi

/** A [DocumentTree] backed by the folder at [treeUri]. */
@RequiresApi(Build.VERSION_CODES.Q)
internal class ContentResolverDocumentTree(
    private val context: Context,
    private val treeUri: Uri,
) : DocumentTree {
    override fun children(documentId: String): List<FolderEntry> {
        val children = DocumentsContract.buildChildDocumentsUriUsingTree(treeUri, documentId)
        val columns = arrayOf(
            DocumentsContract.Document.COLUMN_DOCUMENT_ID,
            DocumentsContract.Document.COLUMN_MIME_TYPE,
        )
        val entries = mutableListOf<FolderEntry>()
        context.contentResolver.query(children, columns, null, null, null)?.use { cursor ->
            while (cursor.moveToNext()) {
                val mimeType = cursor.getString(1)
                entries.add(
                    FolderEntry(
                        documentId = cursor.getString(0),
                        isDirectory = mimeType == DocumentsContract.Document.MIME_TYPE_DIR,
                        isImage = mimeType.startsWith("image/"),
                    ),
                )
            }
        }
        return entries
    }

    override fun mediaId(documentId: String): String? = try {
        MediaStore.getMediaUri(context, documentUri(documentId))?.lastPathSegment
    } catch (e: IllegalArgumentException) {
        null
    }

    fun documentUri(documentId: String): Uri =
        DocumentsContract.buildDocumentUriUsingTree(treeUri, documentId)
}
