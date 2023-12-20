import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit

class MainActivity : FlutterActivity() {
    private val CHANNEL = "face_landmarker_channel"
    private lateinit var faceLandmarkerHelper: FaceLandmarkerHelper
    private lateinit var backgroundExecutor: ExecutorService
    private lateinit var context: Context

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        context = applicationContext
        backgroundExecutor = Executors.newSingleThreadExecutor()
        backgroundExecutor.execute(
            faceLandmarkerHelper =  FaceLandmarkerHelper(
                context = context,
                faceLandmarkerHelperListener = faceLandMarkerListener,
                minFaceDetectionConfidence = 0.5f,
                minFaceTrackingConfidence = 0.5f,
                minFacePresenceConfidence = 0.5f
            )
        )

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "initializeFaceLandmarker" -> {
                    backgroundExecutor.execute {
                        if (faceLandmarkerHelper.isClose()) {
                            faceLandmarkerHelper.setupFaceLandmarker()
                        }
                    }
                    result.success(null)
                }
                "clearFaceLandmarker" -> {
                    if (this::faceLandmarkerHelper.isInitialized) {
                        backgroundExecutor.execute {
                            faceLandmarkerHelper.clearFaceLandmarker()
                        }
                    }
                    result.success(null)
                }
                "shutdown" -> {
                    backgroundExecutor.shutdown()
                    backgroundExecutor.awaitTermination(
                        Long.MAX_VALUE, TimeUnit.NANOSECONDS
                    )
                    result.success(null)
                }
                "processImage" -> {
                    val imageData = call.argument<ByteArray>("imageData")
                    if (imageData != null) {
                        faceLandmarkerHelper.detectLiveStream(imageData)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Image data is null", null)
                    }
                }
            }
        }
    }

    private val faceLandMarkerListener = object : FaceLandmarkerHelper.LandmarkerListener {
        override fun onResults(resultBundle: FaceLandmarkerHelper.ResultBundle) {
            Log.d("result", "$resultBundle")

            val resultMap = mapOf(
                "result" to "ok",
                "data" to resultBundle.toString()
            )
            sendToFlutter("landmarkerCallback", resultMap)
        }

        override fun onError(error: String) {
            Log.d("result", "$error")

            val errorMap = mapOf(
                "result" to "error",
                "data" to error,
            )
            sendToFlutter("landmarkerCallback", errorMap)
        }

        override fun onNoResults() {
            Log.d("result", "no face detected")

            val noResultsMap = mapOf(
                "result" to "empty"
                "data" to "no face present"
            )
            sendToFlutter("landmarkerCallback", noResultsMap)
        }
    }

    private fun sendToFlutter(method: String, arguments: Map<String, Any>) {
        flutterEngine?.dartExecutor?.executeDartCallback(DartCallback {
            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
                .invokeMethod(method, arguments)
        })
    }
}
