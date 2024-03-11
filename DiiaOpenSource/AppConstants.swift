import UIKit
import Alamofire

struct AppConstants {
    
    struct HttpCode {
        static let unauthorized = 401
    }
    
    struct App {
        static let appVersion: String = {
            let infoDictionary = Bundle.main.infoDictionary! // swiftlint:disable:this force_unwrapping
            let majorVersion = infoDictionary["CFBundleShortVersionString"]! // swiftlint:disable:this force_unwrapping
            let minorVersion = infoDictionary["CFBundleVersion"]! // swiftlint:disable:this force_unwrapping
            
            return "\(majorVersion).\(minorVersion)"
        }()
        
        static let appShortVersion: String = {
            let infoDictionary = Bundle.main.infoDictionary! // swiftlint:disable:this force_unwrapping
            let majorVersion = infoDictionary["CFBundleShortVersionString"]! // swiftlint:disable:this force_unwrapping
            
            return "\(majorVersion)"
        }()
        
        static var mobileUID: String = {
            return MobileUIDGenerator().getMobileUID()
        }()
        
        static var iOSVersion: String {
            return UIDevice.current.systemVersion
        }
        
        static let platform = "iOS"
        
        static let userAgent: String = {
            let infoDictionary = Bundle.main.infoDictionary! // swiftlint:disable:this force_unwrapping
            let majorVersion = infoDictionary["CFBundleShortVersionString"]! // swiftlint:disable:this force_unwrapping
            let agent = Alamofire.HTTPHeader.userAgent("DIIA iOS-\(majorVersion)").value
            return agent
        }()
        
        static let defaultPinCodeLength = 4
    }
    
    struct Notifications {
        static let documentsWasReordered = Notification.Name(rawValue: "kNDocumentsWasReordered")
    }
    
    struct Colors {
        static let clear = "#0000000"
        static let black = "#000000"
        static let white = "#FFFFFF"
        static let emptyDocumentsBackground = "#C5D9E9"
        static let documentVerifyLoadingBackground = "#676F76"
    }
}
