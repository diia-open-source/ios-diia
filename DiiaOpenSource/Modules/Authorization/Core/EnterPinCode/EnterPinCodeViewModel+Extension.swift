import Foundation
import DiiaAuthorizationPinCode

// MARK: - Factory
extension EnterPinCodeViewModel {
    static let auth = EnterPinCodeViewModel(
        pinCodeLength: AppConstants.App.defaultPinCodeLength,
        title: R.Strings.authorization_enter_pin_title.localized(),
        forgotTitle: R.Strings.authorization_dont_remember_pin.localized()
    )
}
