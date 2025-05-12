//___FILEHEADER___

import Foundation
import DiiaNetwork
import DiiaCommonTypes

enum ___FILEBASENAMEASIDENTIFIER___: CommonService {
    case getOnboarding
    case getMainScreen
    case getStatusScreen(applicationId: String)
    
    var method: HTTPMethod {
        switch self {
        case .getOnboarding,
             .getMainScreen,
             .getStatusScreen:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getOnboarding:
            return "v1/public-service/___VARIABLE_publicServiceCode:bundleIdentifier___/onboarding"
        case .getMainScreen:
            return "v1/public-service/___VARIABLE_publicServiceCode:bundleIdentifier___/home"
        case .getStatusScreen(let applicationId):
            return "v1/public-service/___VARIABLE_publicServiceCode:bundleIdentifier___/\(applicationId)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    var analyticsName: String {
        switch self {
        case .getOnboarding:
            return NetworkActionKey.___VARIABLE_publicServiceName:identifier___GetOnboarding.rawValue
        case .getMainScreen:
            return NetworkActionKey.___VARIABLE_publicServiceName:identifier___GetMainScreen.rawValue
        case .getStatusScreen:
            return NetworkActionKey.___VARIABLE_publicServiceName:identifier___GetStatusScreen.rawValue
        }
    }
}
