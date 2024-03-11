import UIKit
import DiiaAuthorization

extension Dictionary {
    static var userIdentifyHandlers: [AuthMethod: IdentifyTaskPerformer] {
        AuthMethod.allCases.reduce(into: [:]) {result, authMethod in
            switch authMethod {
            case .bankId:
                result[authMethod] = BankIDIdentifyTask()
            default: return
            }
        }
    }
}
