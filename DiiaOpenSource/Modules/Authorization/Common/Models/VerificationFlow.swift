import Foundation
import DiiaAuthorization
import DiiaCommonTypes

enum VerificationFlow: String, VerificationFlowProtocol {
    
    case prolong
    case authorization
    
    var flowCode: String {
        return rawValue
    }

    var isAuthorization: Bool {
        self == .authorization
    }
    
    var authFlow: AuthFlow {
        switch self {
        case .prolong:
            return .prolong
        case .authorization:
            return .login
        }
    }
}
