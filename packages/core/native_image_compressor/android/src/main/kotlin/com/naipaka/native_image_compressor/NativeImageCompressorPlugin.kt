package com.naipaka.native_image_compressor

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class NativeImageCompressorPlugin :
    FlutterPlugin,
    MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var executor: ExecutorService
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        executor = Executors.newCachedThreadPool()
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        executor.shutdown()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "size" -> runInBackground(result) {
                val size = ImageCompressor.size(call.argument<String>("path")!!)
                listOf(size.width, size.height)
            }
            "compress" -> runInBackground(result) {
                ImageCompressor.compress(
                    path = call.argument<String>("path")!!,
                    width = call.argument<Int>("width")!!,
                    height = call.argument<Int>("height")!!,
                    format = OutputFormat.valueOf(call.argument<String>("format")!!.uppercase()),
                    quality = call.argument<Int>("quality")!!,
                )
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
                mainHandler.post { result.error(ERROR_CODE, e.message ?: e.toString(), null) }
            } catch (e: OutOfMemoryError) {
                mainHandler.post { result.error(ERROR_CODE, e.message ?: e.toString(), null) }
            }
        }
    }

    private companion object {
        const val CHANNEL = "com.naipaka.native_image_compressor"
        const val ERROR_CODE = "native_image_compressor"
    }
}
