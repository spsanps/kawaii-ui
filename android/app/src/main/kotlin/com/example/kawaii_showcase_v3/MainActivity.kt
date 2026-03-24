package com.example.kawaii_showcase_v3

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "kawaii_sound"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "playWav") {
                    val wavBytes = call.arguments as ByteArray
                    playWav(wavBytes)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun playWav(wavBytes: ByteArray) {
        Thread {
            try {
                // Skip WAV header (44 bytes), read PCM data
                val pcmData = wavBytes.copyOfRange(44, wavBytes.size)
                val sampleRate = 22050
                val bufferSize = pcmData.size

                val audioTrack = AudioTrack.Builder()
                    .setAudioAttributes(
                        AudioAttributes.Builder()
                            .setUsage(AudioAttributes.USAGE_GAME)
                            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                            .build()
                    )
                    .setAudioFormat(
                        AudioFormat.Builder()
                            .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                            .setSampleRate(sampleRate)
                            .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                            .build()
                    )
                    .setBufferSizeInBytes(bufferSize)
                    .setTransferMode(AudioTrack.MODE_STATIC)
                    .build()

                audioTrack.write(pcmData, 0, pcmData.size)
                audioTrack.play()

                // Release after playback
                val durationMs = (pcmData.size / 2) * 1000L / sampleRate + 100
                Thread.sleep(durationMs)
                audioTrack.release()
            } catch (e: Exception) {
                // Silently fail - sounds are non-critical
            }
        }.start()
    }
}
