import UIKit

extension R {
    enum image: String {
        // MARK: - Buttons
        case clear
        case telegram
        case facebookMessenger
        case viber
        case menu_back
        case faceId
        case fingerprint
        case qrScanner
        
        // MARK: - Images
        case loadingBar
        case ukrainianGradient
        case light_background
        
        // MARK: - IconsMenu
        case menuNotifications
        case menuDiiaID
        case menuDiiaIDHistory
        case menuUpdate
        case menuActiveSessions
        case menuFaq
        case menuChangePincode
        case menuFaceID
        case menuTouchID
        case menuSupport
        case menuCopyUID
        case menuFeedActive
        case menuFeedInactive
        case menuDocumentsInactive
        case menuDocumentsActive
        case menuServicesInactive
        case menuServicesActive
        case menuSettingsInactive
        case menuSettingsActive
        case settings
        case orderIcon
        
        // MARK: - Icons
        case diia
        case tryzub
        case lightCloseIcon
        
        // MARK: - Frame
        case leftBottom
        case leftTop
        case rightBottom
        case rightTop
        
        // MARK: - DesignSystem icons
        case ds_certificates = "DS_certificates"
        case ds_drag = "DS_drag"
        case ds_placeholder = "DS_placeholder"
        case ds_stack = "DS_stack"
        case ds_ellipseArrowRight = "DS_ellipseArrowRight"
        case ds_copy = "DS_copy"
        case ds_ellipseKebab = "DS_ellipseKebab"

        var image: UIImage? {
            return UIImage(named: rawValue)
        }
        
        var name: String {
            return rawValue
        }
    }
}
