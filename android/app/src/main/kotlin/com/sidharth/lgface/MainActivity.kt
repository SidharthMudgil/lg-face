package com.sidharth.lgface

import com.sidharth.lgface.FaceLandmarkerHelper
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import io.flutter.embedding.engine.FlutterEngine
import androidx.camera.core.ImageProxy
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import java.io.ByteArrayOutputStream;
import com.sidharth.lgface.YuvConverter;


class MainActivity : FlutterActivity() {
    private val CHANNEL = "face_landmarker_channel"
    private lateinit var channel: MethodChannel
    private lateinit var faceLandmarkerHelper: FaceLandmarkerHelper
    private lateinit var backgroundExecutor: ExecutorService
    private lateinit var context: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        installSplashScreen()
        context = applicationContext
        backgroundExecutor = Executors.newSingleThreadExecutor()
        backgroundExecutor.execute {
            faceLandmarkerHelper = FaceLandmarkerHelper(
                context = context,
                faceLandmarkerHelperListener = faceLandMarkerListener,
                minFaceDetectionConfidence = 0.5f,
                minFaceTrackingConfidence = 0.5f,
                minFacePresenceConfidence = 0.5f
            )
        }

        channel = MethodChannel(flutterEngine?.dartExecutor!!.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeFaceLandmarker" -> {
                    backgroundExecutor.execute {
                        if (faceLandmarkerHelper.isClose()) {
                            faceLandmarkerHelper.setupFaceLandmarker()
                        }
                    }
                    result.success("FaceLandmarker intialized")
                }
                "clearFaceLandmarker" -> {
                    if (this::faceLandmarkerHelper.isInitialized) {
                        backgroundExecutor.execute {
                            faceLandmarkerHelper.clearFaceLandmarker()
                        }
                    }
                    result.success("FaceLandmarker cleared")
                }
                "shutdown" -> {
                    backgroundExecutor.shutdown()
                    backgroundExecutor.awaitTermination(
                        Long.MAX_VALUE, TimeUnit.NANOSECONDS
                    )
                    result.success("FaceLandmarker shutdown")
                }
                "processImage" -> {
                    val imageData = call.argument<Map<String, Any>>("imageData")!!
                    val isFrontFacing = call.argument<Boolean>("isFrontFacing")

                    val bytesList  = imageData["platforms"] as List<ByteArray>
                    val strides  = imageData["strides"] as IntArray
                    val width = imageData["width"] as Int
                    val height = imageData["height"] as Int
                    val quality = imageData["quality"] as Int

                    val data: ByteArray = YuvConverter.NV21toJPEG(
                        YuvConverter.YUVtoNV21(
                            bytesList,
                            strides,
                            width,
                            height
                        ), width, height, 100
                    )

                    val bitmapRaw: Bitmap = BitmapFactory.decodeByteArray(data, 0, data.size)
                    val matrix = Matrix()
                    matrix.postRotate(-90 * 1f)
                    val finalbitmap: Bitmap = Bitmap.createBitmap(
                        bitmapRaw,
                        0,
                        0,
                        bitmapRaw.getWidth(),
                        bitmapRaw.getHeight(),
                        matrix,
                        true
                    )
                    if (imageData != null && isFrontFacing != null) {
                        faceLandmarkerHelper.detectLiveStream(finalbitmap, width, height, isFrontFacing)
                        result.success("Facelandmarker detectLiveSteam called")
                    } else {
                        result.error("INVALID_ARGUMENT", "Image data is null", null)
                    }
                }
            }
        }
    }

    private val faceLandMarkerListener = object : FaceLandmarkerHelper.LandmarkerListener {
        override fun onResults(blendshapes: Map<String, Float>) {
            val resultMap = mapOf("data" to blendshapes.toString())
            Handler(Looper.getMainLooper()).postDelayed (
                Runnable { channel.invokeMethod("onResult", resultMap) }, 0
            )
        }

        override fun onError(error: String) {
            val errorMap = mapOf("data" to error)
            Handler(Looper.getMainLooper()).postDelayed (
                Runnable { channel.invokeMethod("onError", errorMap) }, 0
            )
        }

        override fun onNoResults() {
            val noResultsMap = mapOf("data" to "no face present")
            Handler(Looper.getMainLooper()).postDelayed (
                Runnable { channel.invokeMethod("onNoResult", noResultsMap) }, 0
            )
        }
    }
}
