import UIKit
import AVFoundation
import DiiaUIComponents

enum CameraAccessChecker {
    static func askCameraAccess(in viewController: UIViewController? = nil, handler: @escaping (Bool) -> Void) {
        let cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraPermissionStatus {
        case .authorized:
            handler(true)
        case .denied:
            AccessHelper.showSettingsAlert(with: R.Strings.permissions_camera_not_granted.localized(), message: R.Strings.permissions_camera_settings.localized(), in: viewController, action: handler)
        case .restricted:
            handler(false)
        default:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) -> Void in
                onMainQueue {
                    handler(granted)
                }
            })
        }
    }
}
