package com.naipaka.device_photos

import android.Manifest
import android.app.Activity
import android.content.ContentUris
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
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

/** Gives Dart access to the photos the user allows. */
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
    private var pendingPhotosResult: MethodChannel.Result? = null
    private var requestedPhotos: Map<String, Uri> = emptyMap()

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
            "shouldShowRationale" -> result.success(
                binding?.activity?.shouldShowRequestPermissionRationale(
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                ) ?: false,
            )
            "copyDocument" -> runInBackground(result) {
                copyDocument(Uri.parse(call.argument<String>("document")))
            }
            "availablePhotos" -> runInBackground(result) {
                availablePhotos(call.argument<List<String>>("ids").orEmpty()).keys.toList()
            }
            "requestPhotos" -> requestPhotos(call.argument<List<String>>("ids").orEmpty(), result)
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

    @RequiresApi(Build.VERSION_CODES.R)
    private fun requestPhotos(ids: List<String>, result: MethodChannel.Result) {
        val activity = binding?.activity
        if (activity == null) {
            result.error(ERROR_CODE, "No activity is attached.", null)
            return
        }
        val photos = availablePhotos(ids)
        if (photos.isEmpty()) {
            result.success(emptyMap<String, String>())
            return
        }
        val request = MediaStore.createWriteRequest(context.contentResolver, photos.values)
        pendingPhotosResult = result
        requestedPhotos = photos
        activity.startIntentSenderForResult(
            request.intentSender,
            REQUEST_PHOTOS_REQUEST,
            null,
            0,
            0,
            0,
        )
    }

    // A write request fails for the whole list if one photo is missing, so
    // each photo is checked with a request of its own, which is never shown.
    @RequiresApi(Build.VERSION_CODES.R)
    private fun availablePhotos(ids: List<String>): Map<String, Uri> = ids
        .associateWith { id ->
            ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id.toLong())
        }
        .filterValues { uri ->
            try {
                MediaStore.createWriteRequest(context.contentResolver, listOf(uri))
                true
            } catch (e: IllegalArgumentException) {
                false
            }
        }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        when (requestCode) {
            REQUEST_PHOTOS_REQUEST -> {
                val photos = if (resultCode == Activity.RESULT_OK) {
                    requestedPhotos.mapValues { (_, uri) -> uri.toString() }
                } else {
                    null
                }
                pendingPhotosResult?.success(photos)
                pendingPhotosResult = null
                requestedPhotos = emptyMap()
            }
            else -> return false
        }
        return true
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
        const val REQUEST_PHOTOS_REQUEST = 0x5053
    }
}
