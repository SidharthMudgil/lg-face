package com.sidharth.lgface

import com.sidharth.lgface.FaceLandmarkerHelper
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


class MainActivity : FlutterActivity() {
    private val CHANNEL = "face_landmarker_channel"
    private lateinit var channel: MethodChannel
    private lateinit var faceLandmarkerHelper: FaceLandmarkerHelper
    private lateinit var backgroundExecutor: ExecutorService
    private lateinit var context: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
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
                    val imageData = call.argument<Map<String, Any>>("imageData")
                    val isFrontFacing = call.argument<Boolean>("isFrontFacing")

                    val noResultsMap = mapOf("data" to "no face present")
                    Handler(Looper.getMainLooper()).postDelayed (
                        Runnable {
                            channel.invokeMethod("onNoResult", noResultsMap)
                        }, 0
                    )

                    if (imageData != null && isFrontFacing != null) {
//                        faceLandmarkerHelper.detectLiveStream(imageData, isFrontFacing)
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
            Log.d("result", "$blendshapes")
            val resultMap = mapOf("data" to blendshapes.toString())
            channel.invokeMethod("onResult", resultMap)
        }

        override fun onError(error: String) {
            Log.d("result", "$error")
            val errorMap = mapOf("data" to error,)
            channel.invokeMethod("onError", errorMap)
        }

        override fun onNoResults() {
            Log.d("result", "no face detected")
            val noResultsMap = mapOf("data" to "no face present")
            channel.invokeMethod("onNoResult", noResultsMap)
        }
    }
}
