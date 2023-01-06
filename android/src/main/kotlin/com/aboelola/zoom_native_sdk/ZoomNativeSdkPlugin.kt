package com.aboelola.zoom_native_sdk

import android.app.Activity
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import us.zoom.sdk.*

/** ZoomNativeSdkPlugin */
class ZoomNativeSdkPlugin FlutterPlugin, MethodCallHandler, MeetingServiceListener,
ZoomSDKInitializeListener, ActivityAware {

//    private val statusListener: MeetingServiceListener? = null

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    private val WEB_DOMAIN = "zoom.us"
    private var zoomSDK: ZoomSDK? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zoom_natively")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initZoom" -> {
                val arguments: Map<String, String>? = call.arguments<Map<String, String>>()
                initZoom(arguments?.get("appKey"), arguments?.get("appSecret"))
                result.success(true)
            }
            "joinMeeting" -> {
                val arguments: Map<String, String>? = call.arguments<Map<String, String>>()
                joinMeeting(arguments?.get("meetingNumber"), arguments?.get("meetingPassword"))
                Log.d("TAG", "onMethodCall: $arguments")
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    fun initZoom(appKey: String?, appSecret: String?) {
        zoomSDK = ZoomSDK.getInstance()
        val initParams = ZoomSDKInitParams()
        initParams.domain = WEB_DOMAIN
        initParams.appKey = appKey
        initParams.appSecret = appSecret

        zoomSDK?.initialize(activity, this, initParams)
    }

    fun joinMeeting(meetingId: String?, meetingPassword: String?) {

        val meetingService = zoomSDK?.meetingService
        val opts = JoinMeetingOptions()

        opts.no_invite = true
        opts.no_driving_mode = false
        opts.no_dial_in_via_phone = true
        opts.no_disconnect_audio = false
        opts.no_audio = false
        opts.no_titlebar = true
        val view_options = true
        if (view_options) {
            opts.meeting_views_options =
                MeetingViewsOptions.NO_TEXT_MEETING_ID + MeetingViewsOptions.NO_TEXT_PASSWORD
        }

        val params = JoinMeetingParams()
        params.meetingNo = meetingId
        params.password = meetingPassword

        meetingService?.joinMeetingWithParams(activity, params, opts)
    }

    override fun onMeetingStatusChanged(p0: MeetingStatus?, p1: Int, p2: Int) {
        Log.d("TAG", "onMeetingStatusChanged: $p0")
    }

    override fun onMeetingParameterNotification(p0: MeetingParameter?) {
        Log.d("TAG", "onMeetingParameterNotification: $p0")

    }

    override fun onZoomSDKInitializeResult(p0: Int, p1: Int) {
        Log.d("TAG", "onZoomSDKInitializeResult: $p0 , $p1")
    }

    override fun onZoomAuthIdentityExpired() {
        Log.d("TAG", "onZoomAuthIdentityExpired")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        channel.setMethodCallHandler(null);
    }
}