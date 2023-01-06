import Flutter
import UIKit
import MobileRTC
public class SwiftZoomNativeSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "zoom_natively", binaryMessenger: registrar.messenger())
        let instance = SwiftZoomNativeSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("initZoom .......")

        if call.method == "initZoom" {
            //let sdkKey = "nCwNhSvGIJ9PPhastf2HCqUaqyPJknbxWM6h"
            //let sdkSecret = "ik4BqddCAgN2viaRtF3HgU27pqaXHodMSzCq"
            guard let args = call.arguments as? Dictionary<String, String> else { return }
            let sdkKey = args["appKey"] ?? ""
            let sdkSecret = args["appSecret"] ?? ""
            setupSDK(sdkKey: sdkKey, sdkSecret: sdkSecret)
            result(true)
        }

        if call.method == "joinMeeting" {
            guard let args = call.arguments as? Dictionary<String, String> else { return }
            let meetingNumber = args["meetingNumber"] ?? ""
            let meetingPassword = args["meetingPassword"] ?? ""


            self.joinMeeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword)
        }

    }


    func getDeviceID() -> String {
        print("Hello From method")
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

    }

    func getRootController() -> UIViewController {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        let topController = (keyWindow?.rootViewController)!
        return topController
    }
}
extension SwiftZoomNativeSdkPlugin{

    func joinAMeetingButtonPressed(meetingNumber: String, meetingPassword: String){
        //        requestSaveClientJoiningTime(id: id)

        // 1. The Zoom SDK requires a UINavigationController to update the UI for us. Here we are supplying the SDK with the ViewControllers' navigationController.
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        //     window?.makeKeyAndVisible()
        // start your meetingA
        //        joinMeeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword)
    }

    func joinMeeting(meetingNumber: String, meetingPassword: String) {
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        print("Hello From method")
        if let meetingService = MobileRTC.shared().getMeetingService() {
            print("meetingNumber  \(meetingNumber)")
            print("meetingPassword  \(meetingPassword)")


            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            meetingService.delegate = self

            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword
            joinMeetingParameters.noVideo = true
            joinMeetingParameters.noAudio = true

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.muteMyVideo(true)
            meetingService.muteMyAudio(false)

            //            meetingService.video
            meetingService.joinMeeting(with: joinMeetingParameters)
        }else{
            print("Hello From ffffff")

        }
    }

}
extension SwiftZoomNativeSdkPlugin: MobileRTCMeetingServiceDelegate {

    // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
    public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        switch error {
        case MobileRTCMeetError.passwordError:
            print("MobileRTCMeeting   :   Could not join or start meeting because the meeting password was incorrect.")
        default:
            print("MobileRTCMeeting   :   Could not join or start meeting with MobileRTCMeetError: \(error) \(message ?? "")")
        }
    }

    // Is called when the user joins a meeting.
    public func onJoinMeetingConfirmed() {
        print("MobileRTCMeeting   :   Join meeting confirmed.")
    }

    // Is called upon meeting state changes.
    public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("MobileRTCMeeting   :   Current meeting state: \(state.rawValue)")
        switch state{

        case .idle:
            print("idle")
        case .connecting:
            print("connecting")

        case .waitingForHost:
            print("waitingForHost")

        case .inMeeting:
            print("inMeeting")

        case .disconnecting:
            print("disconnecting")

        case .reconnecting:
            print("reconnecting")

        case .failed:
            print("failed")

        case .ended:
            print("ended")

        case .unknow:
            print("unknow")

        case .locked:
            print("locked")

        case .unlocked:
            print("unlocked")

        case .inWaitingRoom:
            print("inWaitingRoom")

        case .webinarPromote:
            print("webinarPromote")

        case .webinarDePromote:
            print("webinarDePromote")

        case .joinBO:
            print("joinBO")

        case .leaveBO:
            print("leaveBO")

        case .waitingExternalSessionKey:
            print("waitingExternalSessionKey")
        @unknown default:
            break
        }
    }
}


extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}



extension SwiftZoomNativeSdkPlugin: MobileRTCAuthDelegate {

    /// setupSDK Creates, Initializes, and Authorizes an instance of the Zoom SDK. This must be called before calling any other SDK functions.

    /// - Parameters:
    ///   - sdkKey: A valid SDK Client Key provided by the Zoom Marketplace.
    ///   - sdkSecret: A valid SDK Client Secret provided by the Zoom Marketplace.
    func setupSDK(sdkKey: String, sdkSecret: String) {
        let context = MobileRTCSDKInitContext()
        context.domain = "zoom.us"
        context.enableLog = false

        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)

        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
            authorizationService.delegate = self
            authorizationService.clientKey = sdkKey
            authorizationService.clientSecret = sdkSecret
            authorizationService.sdkAuth()
        }
    }

    // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.
    public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        switch returnValue {
        case MobileRTCAuthError.success:
            print("SDK successfully initialized.")
        case MobileRTCAuthError.keyOrSecretEmpty:
            print("SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
        case MobileRTCAuthError.keyOrSecretWrong, MobileRTCAuthError.unknown:
            print("SDK Key/Secret is not valid.")
        default:
            print("SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
        }
    }

    private func onMobileRTCLoginReturn(_ returnValue: Int) {
        switch returnValue {
        case 0:
            print("Successfully logged in")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
        case 1002:
            print("Password incorrect")
        default:
            print("Could not log in. Error code: \(returnValue)")
        }
    }
    public func onMobileRTCLogoutReturn(_ returnValue: Int) {
        switch returnValue {
        case 0:
            print("Successfully logged out")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
        default:
            print("Could not log out. Error code: \(returnValue)")
        }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
        if let authorizationService = MobileRTC.shared().getAuthService() {

            // Call logoutRTC() to log the user out.
            authorizationService.logoutRTC()
        }
    }
}


