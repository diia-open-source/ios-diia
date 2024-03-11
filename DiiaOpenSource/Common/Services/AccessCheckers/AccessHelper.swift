import UIKit

struct AccessHelper {
    static func showSettingsAlert(with title: String, message: String, in viewController: UIViewController? = nil, action: ((Bool) -> Void)? = nil) {
        let vc = viewController ?? UIApplication.shared.keyWindow?.visibleViewController
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: R.Strings.permissions_settings.localized(), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                    action?(false)
                })
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: R.Strings.permissions_exit.localized(), style: .default, handler: { (_) -> Void in
            action?(false)
        })
        alertController.addAction(cancelAction)
        
        vc?.present(alertController, animated: true, completion: nil)
    }
}
