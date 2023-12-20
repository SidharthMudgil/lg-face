package com.sidharth.lg_motion.util

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.os.SystemClock
import android.util.Log
import androidx.annotation.VisibleForTesting
import androidx.camera.core.ImageProxy
import com.google.mediapipe.framework.image.BitmapImageBuilder
import com.google.mediapipe.framework.image.MPImage
import com.google.mediapipe.tasks.core.BaseOptions
import com.google.mediapipe.tasks.core.Delegate
import com.google.mediapipe.tasks.vision.core.RunningMode
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarker
import com.google.mediapipe.tasks.vision.facelandmarker.FaceLandmarkerResult

class FaceLandmarkerHelper(
    val context: Context,
    val faceLandmarkerHelperListener: LandmarkerListener? = null,
    val minFaceDetectionConfidence: Float,
    val minFaceTrackingConfidence: Float,
    val minFacePresenceConfidence: Float,
) {
    private var faceLandmarker: FaceLandmarker? = null

    init {
        setupFaceLandmarker()
    }

    fun clearFaceLandmarker() {
        faceLandmarker?.close()
        faceLandmarker = null
    }

    fun isClose(): Boolean {
        return faceLandmarker == null
    }

    fun setupFaceLandmarker() {
        try {
            val baseOptions = BaseOptions.builder()
                .setDelegate(Delegate.CPU)
                .setModelAssetPath("face_landmarker.task")
                .build()

            val options = FaceLandmarker.FaceLandmarkerOptions.builder()
                .setBaseOptions(baseOptions)
                .setMinFaceDetectionConfidence(minFaceDetectionConfidence)
                .setMinTrackingConfidence(minFaceTrackingConfidence)
                .setMinFacePresenceConfidence(minFacePresenceConfidence)
                .setNumFaces(1)
                .setRunningMode(RunningMode.LIVE_STREAM)
                .setOutputFaceBlendshapes(true)
                .setResultListener(this::returnLivestreamResult)
                .setErrorListener(this::returnLivestreamError)
                .build()

            faceLandmarker = FaceLandmarker.createFromOptions(context, options)
        } catch (e: IllegalStateException) {
            faceLandmarkerHelperListener?.onError("Face Landmarker failed to initialize")
            Log.e(TAG, "MediaPipe failed to load the task with error: " + e.message)
        } catch (e: RuntimeException) {
            faceLandmarkerHelperListener?.onError("Face Landmarker failed to initialize", 1)
            Log.e(TAG, "Face Landmarker failed to load model with error: " + e.message)
        }
    }

    fun detectLiveStream(
        imageProxy: ImageProxy,
        isFrontCamera: Boolean
    ) {
        val frameTime = SystemClock.uptimeMillis()

        val bitmapBuffer = Bitmap.createBitmap(
            imageProxy.width,
            imageProxy.height,
            Bitmap.Config.ARGB_8888
        )

        imageProxy.use {
            bitmapBuffer.copyPixelsFromBuffer(imageProxy.planes[0].buffer)
        }
        imageProxy.close()

        val matrix = Matrix().apply {
            postRotate(imageProxy.imageInfo.rotationDegrees.toFloat())
            if (isFrontCamera) {
                postScale(
                    -1f,
                    1f,
                    imageProxy.width.toFloat(),
                    imageProxy.height.toFloat()
                )
            }
        }
        val rotatedBitmap = Bitmap.createBitmap(
            bitmapBuffer, 0, 0, bitmapBuffer.width, bitmapBuffer.height,
            matrix, true
        )

        val mpImage = BitmapImageBuilder(rotatedBitmap).build()
        detectAsync(mpImage, frameTime)
    }

    @VisibleForTesting
    fun detectAsync(mpImage: MPImage, frameTime: Long) {
        faceLandmarker?.detectAsync(mpImage, frameTime)
    }

    private fun returnLivestreamResult(
        result: FaceLandmarkerResult,
        input: MPImage
    ) {
        if (result.faceLandmarks().size > 0) {
            val finishTimeMs = SystemClock.uptimeMillis()
            val inferenceTime = finishTimeMs - result.timestampMs()
            val blendshapes = result.faceBlendshapes().get()[0]
                .associateBy { it.categoryName().trim('_') }
                .mapValues { it.value.score() }

            faceLandmarkerHelperListener?.onResults(blendshapes)
        } else {
            faceLandmarkerHelperListener?.onNoResults()
        }
    }

    private fun returnLivestreamError(error: RuntimeException) {
        faceLandmarkerHelperListener?.onError(
            error.message ?: "An unknown error has occurred"
        )
    }

    companion object {
        const val TAG = "FaceLandmarkerHelper"
    }

    interface LandmarkerListener {
        fun onError(error: String)
        fun onResults(blendshapes: Map<String, Float>)
        fun onNoResults()
    }
}
