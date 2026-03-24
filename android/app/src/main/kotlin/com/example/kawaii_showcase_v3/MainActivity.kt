package com.example.kawaii_showcase_v3

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val SOUND_CHANNEL = "kawaii_sound"
    private val HAPTIC_CHANNEL = "kawaii_haptics"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Sound channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SOUND_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "playWav") {
                    val wavBytes = call.arguments as ByteArray
                    playWav(wavBytes)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }

        // Haptics channel — direct Vibrator API for strong, quality feedback
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HAPTIC_CHANNEL)
            .setMethodCallHandler { call, result ->
                val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    val vm = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager
                    vm.defaultVibrator
                } else {
                    @Suppress("DEPRECATION")
                    getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
                }

                when (call.method) {
                    "vibrate" -> {
                        val duration = call.argument<Int>("duration")?.toLong() ?: 50L
                        val amplitude = call.argument<Int>("amplitude") ?: 255
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            vibrator.vibrate(VibrationEffect.createOneShot(duration, amplitude))
                        } else {
                            @Suppress("DEPRECATION")
                            vibrator.vibrate(duration)
                        }
                        result.success(null)
                    }
                    "predefined" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            val effectId = when (call.argument<String>("effect")) {
                                "click" -> VibrationEffect.EFFECT_CLICK
                                "heavy_click" -> VibrationEffect.EFFECT_HEAVY_CLICK
                                "double_click" -> VibrationEffect.EFFECT_DOUBLE_CLICK
                                "tick" -> VibrationEffect.EFFECT_TICK
                                else -> VibrationEffect.EFFECT_CLICK
                            }
                            vibrator.vibrate(VibrationEffect.createPredefined(effectId))
                        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            vibrator.vibrate(VibrationEffect.createOneShot(40, 255))
                        } else {
                            @Suppress("DEPRECATION")
                            vibrator.vibrate(40)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun playWav(wavBytes: ByteArray) {
        Thread {
            try {
                val pcmData = wavBytes.copyOfRange(44, wavBytes.size)
                val sampleRate = 22050
                val audioTrack = AudioTrack.Builder()
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_GAME)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build())
                    .setAudioFormat(
                        AudioFormat.Builder()
                            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                            .setSampleRate(sampleRate)
                            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                            .build())
                    .setBufferSizeInBytes(pcmData.size)
                    .setTransferMode(AudioTrack.MODE_STATIC)
                    .build()
                audioTrack.write(pcmData, 0, pcmData.size)
                audioTrack.play()
                val durationMs = (pcmData.size / 2) * 1000L / sampleRate + 100
                Thread.sleep(durationMs)
                audioTrack.release()
            } catch (e: Exception) { }
        }.start()
    }
}
