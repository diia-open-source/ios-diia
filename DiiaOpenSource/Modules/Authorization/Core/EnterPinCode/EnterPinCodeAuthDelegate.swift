import Foundation
import DiiaAuthorizationPinCode
import DiiaMVPModule
import DiiaUIComponents

final class EnterPinCodeAuthDelegate: EnterPinCodeDelegate {
    // MARK: - Private properties
    private let completionHandler: (Result<String, Error>) -> Void

    // MARK: - Initialization
    init(completionHandler: @escaping (Result<String, Error>) -> Void) {
        self.completionHandler = completionHandler
    }
    
    // MARK: - EnterPinCodeDelegate
    func checkPincode(_ pincode: [Int]) -> Bool {
        return ServicesProvider.shared.authService.checkPincode(pincode: pincode)
    }
    
    func onForgotPincode(in view: BaseView) {
        let actions = [
            AlertAction(
                title: R.Strings.authorization_authorize.localized(),
                type: .destructive,
                callback: {
                    ServicesProvider.shared.authService.logout()
                }
            ),
            AlertAction(
                title: R.Strings.general_cancel.localized(),
                type: .normal,
                callback: {}
            )
        ]
        let module = CustomAlertModule(title: R.Strings.authorization_forget.localized(),
                                       message: R.Strings.authorization_repeat.localized(),
                                       actions: actions)
        view.showChild(module: module)
    }
    
    func didAllAttemptsExhausted(in view: BaseView) {
        StoreHelper.instance.clearAllData()
        let actions = [
            AlertAction(
                title: R.Strings.authorization_authorize.localized(),
                type: .normal,
                callback: {
                    ServicesProvider.shared.authService.logout()
                }
            )
        ]
        let module = CustomAlertModule(title: R.Strings.authorization_triple_error.localized(),
                                       message: R.Strings.authorization_repeat.localized(),
                                       actions: actions)
        view.showChild(module: module)
    }
    
    func didCorrectPincodeEntered(pincode: String) {
        completionHandler(.success(pincode))
    }
}
