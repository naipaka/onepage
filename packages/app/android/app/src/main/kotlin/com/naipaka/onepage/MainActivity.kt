package com.naipaka.onepage

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.DocumentsContract
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val executor = Executors.newSingleThreadExecutor()
    private var pendingFolderResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(::handleCall)
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "sdkInt" -> result.success(Build.VERSION.SDK_INT)
            "pickFolder" -> pickFolder(result)
            "findInFolder" -> runInBackground(result) {
                val folder = Uri.parse(call.argument<String>("folder"))
                val ids = call.argument<List<String>>("ids").orEmpty().toSet()
                findInFolder(folder, ids)
            }
            "copyDocument" -> runInBackground(result) {
                copyDocument(Uri.parse(call.argument<String>("document")))
            }
            else -> result.notImplemented()
        }
    }

    private fun runInBackground(result: MethodChannel.Result, task: () -> Any) {
        executor.execute {
            try {
                val value = task()
                runOnUiThread { result.success(value) }
            } catch (e: Exception) {
                runOnUiThread { result.error("photo_library", e.message, null) }
            }
        }
    }

    private fun pickFolder(result: MethodChannel.Result) {
        pendingFolderResult = result
        startActivityForResult(Intent(Intent.ACTION_OPEN_DOCUMENT_TREE), PICK_FOLDER_REQUEST)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != PICK_FOLDER_REQUEST) {
            return
        }
        val folder = if (resultCode == Activity.RESULT_OK) data?.data else null
        pendingFolderResult?.success(folder?.toString())
        pendingFolderResult = null
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun findInFolder(folder: Uri, ids: Set<String>): Map<String, String> {
        val found = mutableMapOf<String, String>()
        val folders = ArrayDeque(listOf(DocumentsContract.getTreeDocumentId(folder)))
        while (folders.isNotEmpty() && found.size < ids.size) {
            val children = DocumentsContract.buildChildDocumentsUriUsingTree(
                folder,
                folders.removeFirst(),
            )
            val columns = arrayOf(
                DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                DocumentsContract.Document.COLUMN_MIME_TYPE,
            )
            contentResolver.query(children, columns, null, null, null)?.use { cursor ->
                while (cursor.moveToNext()) {
                    val documentId = cursor.getString(0)
                    val mimeType = cursor.getString(1)
                    if (mimeType == DocumentsContract.Document.MIME_TYPE_DIR) {
                        folders.addLast(documentId)
                    } else if (mimeType.startsWith("image/")) {
                        val document =
                            DocumentsContract.buildDocumentUriUsingTree(folder, documentId)
                        val id = mediaId(document)
                        if (id in ids) {
                            found[id!!] = document.toString()
                        }
                    }
                }
            }
        }
        return found
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun mediaId(document: Uri): String? = try {
        MediaStore.getMediaUri(this, document)?.lastPathSegment
    } catch (e: IllegalArgumentException) {
        null
    }

    private fun copyDocument(document: Uri): String {
        val copy = File.createTempFile("photo_recovery", null, cacheDir)
        contentResolver.openInputStream(document)!!.use { input ->
            copy.outputStream().use { output -> input.copyTo(output) }
        }
        return copy.path
    }

    private companion object {
        const val CHANNEL = "com.naipaka.onepage/photo_library"
        const val PICK_FOLDER_REQUEST = 0x5052
    }
}
