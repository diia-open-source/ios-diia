import Foundation
import DiiaAuthorizationPinCode
import DiiaMVPModule

extension EnterPinCodeModuleContext {

    static func create(flow: EnterPinCodeFlow, completionHandler: @escaping (Result<String, Error>) -> Void) -> EnterPinCodeModuleContext {

        let delegate: EnterPinCodeDelegate
        switch flow {
        case .auth:
            delegate = EnterPinCodeAuthDelegate(completionHandler: completionHandler)
        case .diiaId:
            // this is a just context initializator demand, must never be called for DiiaOpenSource once it doesn't use diiaId
            delegate = EnterPinCodeDefaultDelegate(completionHandler: completionHandler)
        }
        
        return EnterPinCodeModuleContext(storage: PinCodeStorage(storage: StoreHelper.instance),
                                         enterPinCodeDelegate: delegate)
    }
}

final class EnterPinCodeDefaultDelegate: EnterPinCodeDelegate {
    
    init(completionHandler: @escaping (Result<String, Error>) -> Void) {

    }
    
    // MARK: - EnterPinCodeDelegate
    func onForgotPincode(in view: BaseView) {}
    
    func didAllAttemptsExhausted(in view: BaseView) {}
    
    func checkPincode(_ pincode: [Int]) -> Bool {
        return false
    }
    
    func didCorrectPincodeEntered(pincode: String) {}
}
