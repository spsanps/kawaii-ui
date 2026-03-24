package com.example.kawaii_showcase_v3

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import android.media.SoundPool
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val SOUND_CHANNEL = "kawaii_sound"
    private val HAPTIC_CHANNEL = "kawaii_haptics"

    // SoundPool for low-latency playback — pre-loaded sounds play instantly
    private var soundPool: SoundPool? = null
    private val loadedSounds = mutableMapOf<String, Int>()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Initialize SoundPool with low-latency attributes
        val audioAttrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_GAME)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        soundPool = SoundPool.Builder()
            .setMaxStreams(4)
            .setAudioAttributes(audioAttrs)
            .build()

        // Sound channel — pre-load WAVs into SoundPool for instant playback
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SOUND_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "preloadWav" -> {
                        // Pre-load a named sound into SoundPool
                        val name = call.argument<String>("name") ?: ""
                        val wavBytes = call.argument<ByteArray>("data") ?: ByteArray(0)
                        if (name.isNotEmpty() && wavBytes.isNotEmpty()) {
                            try {
                                // Write WAV to temp file, load into SoundPool
                                val file = File(cacheDir, "kawaii_$name.wav")
                                FileOutputStream(file).use { it.write(wavBytes) }
                                val soundId = soundPool!!.load(file.absolutePath, 1)
                                loadedSounds[name] = soundId
                            } catch (e: Exception) { }
                        }
                        result.success(null)
                    }
                    "playSound" -> {
                        // Play a pre-loaded sound — near instant
                        val name = call.argument<String>("name") ?: ""
                        val soundId = loadedSounds[name]
                        if (soundId != null) {
                            soundPool?.play(soundId, 1.0f, 1.0f, 1, 0, 1.0f)
                        }
                        result.success(null)
                    }
                    "playWav" -> {
                        // Legacy: direct WAV playback (slower, for backwards compat)
                        val wavBytes = call.arguments as ByteArray
                        playWav(wavBytes)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // Haptics channel
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

    override fun onDestroy() {
        soundPool?.release()
        soundPool = null
        super.onDestroy()
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
