package com.naipaka.device_photos

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.DocumentsContract
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/** Gives Dart access to folders the user selects. */
class DevicePhotosPlugin :
    FlutterPlugin,
    ActivityAware,
    MethodChannel.MethodCallHandler,
    PluginRegistry.ActivityResultListener {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var executor: ExecutorService
    private val mainHandler = Handler(Looper.getMainLooper())
    private var binding: ActivityPluginBinding? = null
    private var pendingFolderResult: MethodChannel.Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        executor = Executors.newSingleThreadExecutor()
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        executor.shutdown()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
        onAttachedToActivity(binding)

    override fun onDetachedFromActivity() {
        binding?.removeActivityResultListener(this)
        binding = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "sdkInt" -> result.success(Build.VERSION.SDK_INT)
            "pickFolder" -> pickFolder(result)
            "shouldShowRationale" -> result.success(
                binding?.activity?.shouldShowRequestPermissionRationale(
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                ) ?: false,
            )
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
                mainHandler.post { result.success(value) }
            } catch (e: Exception) {
                mainHandler.post { result.error(ERROR_CODE, e.message, null) }
            }
        }
    }

    private fun pickFolder(result: MethodChannel.Result) {
        val activity = binding?.activity
        if (activity == null) {
            result.error(ERROR_CODE, "No activity is attached.", null)
            return
        }
        pendingFolderResult = result
        activity.startActivityForResult(
            Intent(Intent.ACTION_OPEN_DOCUMENT_TREE),
            PICK_FOLDER_REQUEST,
        )
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != PICK_FOLDER_REQUEST) {
            return false
        }
        val folder = if (resultCode == Activity.RESULT_OK) data?.data else null
        pendingFolderResult?.success(folder?.toString())
        pendingFolderResult = null
        return true
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    private fun findInFolder(folder: Uri, ids: Set<String>): Map<String, String> {
        val tree = ContentResolverDocumentTree(context, folder)
        val rootId = DocumentsContract.getTreeDocumentId(folder)
        return FolderScanner(tree).find(rootId, ids)
            .mapValues { (_, documentId) -> tree.documentUri(documentId).toString() }
    }

    private fun copyDocument(document: Uri): String {
        val copy = File.createTempFile("device_photo", null, context.cacheDir)
        context.contentResolver.openInputStream(document)!!.use { input ->
            copy.outputStream().use { output -> input.copyTo(output) }
        }
        return copy.path
    }

    private companion object {
        const val CHANNEL = "com.naipaka.device_photos"
        const val ERROR_CODE = "device_photos"
        const val PICK_FOLDER_REQUEST = 0x5052
    }
}
