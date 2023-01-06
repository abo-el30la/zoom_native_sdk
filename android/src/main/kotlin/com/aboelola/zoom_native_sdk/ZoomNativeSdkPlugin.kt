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

    /// The MethodChannel that will the communication between Flutter and native Android
    // *** domain: "zoom.us",
    // *** appKey: "Z07vF5qrOaskO7Bc42OpgSn4ml1AalMPXQhT", //API KEY FROM ZOOM
    // *** appSecret: "BHOJoOcIWc96CV5bZ5heLVDszOCrl7vhA3jp", //API SECRET FROM ZOOM
    //"consultingOrders":[{"reservationNumber":"20","doctorId":3,"doctorExaminationPeriod":20,"doctorName":"مصطفي سعد",
    // "doctorFullFilePath":"Files/Doctors/300x300_2597fa34-d0f3-4095-939e-84f747da39e9.jpg","doctorDoctorTitle":4,
    // "doctorOtherTitle":null,"doctorTotalRates":3.5,"consultingDate":"2022-12-16T00:00:00Z","consultingTime":"15:40:00",
    // "meetingId":82001321528,"meetingUserName":82001321528,"meetingPassword":"MFViZk5sYzJoNGhjSThuV3lUM3NXQT09",
    // "hostMeetingUrl":"https://us06web.zoom.us/s/82001321528?zak=eyJ0eXAiOiJKV1QiLCJzdiI6IjAwMDAwMSIsInptX3NrbSI6InptX28ybSIsImFsZyI6IkhTMjU2In0.eyJhdWQiOiJjbGllbnRzbSIsInVpZCI6InJfNVlyRWoyUmVldEpQbEhOYVB4blEiLCJpc3MiOiJ3ZWIiLCJzayI6IjAiLCJzdHkiOjEsIndjZCI6InVzMDYiLCJjbHQiOjAsIm1udW0iOiI4MjAwMTMyMTUyOCIsImV4cCI6MTY3MTEyNTQwNiwiaWF0IjoxNjcxMTE4MjA2LCJhaWQiOiJFcDM3ZHRHNFRkS0FmMjM4clFad09RIiwiY2lkIjoiIn0.x954Rh7kTMDzRcwClXoLH_DpCjXVYcGG4SGWrbjc6x8"
    // ,"clientMeetingUrl":"https://us06web.zoom.us/j/82001321528","mobileMeetingUrl":"55555555","examinationPrice":50.0
    /// when the Flutter Engine is detached from the Activity

//    private val appSecret = "ik4BqddCAgN2viaRtF3HgU27pqaXHodMSzCq"
//    private val appKey = "nCwNhSvGIJ9PPhastf2HCqUaqyPJknbxWM6h"

    // private val meetingId = "82001321528"
    //private val meetingPassword = "MFViZk5sYzJoNGhjSThuV3lUM3NXQT09"
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