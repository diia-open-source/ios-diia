import UIKit
import DiiaAuthorizationPinCode
import DiiaMVPModule
import DiiaUIComponents
import DiiaAuthorization
import DiiaCommonTypes
import DiiaCommonServices

private let incorrectCountsAllowed = 3

extension ChangePincodeModuleContext {
    static func create() -> ChangePincodeModuleContext {
        
        let onOldPincodeWrongValue: (BaseView?) -> Void = { view in
            let storeHelper = StoreHelper.instance
            let incorrectCount: Int = (storeHelper.getValue(forKey: .incorrectPincodeChangeCount) ?? 0) + 1
            if incorrectCount < incorrectCountsAllowed {
                storeHelper.save(incorrectCount, type: Int.self, forKey: .incorrectPincodeChangeCount)
            } else {
                storeHelper.clearAllData()
                let alertAction = AlertAction(title: R.Strings.authorization_authorize.localized(),
                                              type: .normal,
                                              callback: {
                                                ServicesProvider.shared.authService.logout()
                                            })
                let module = CustomAlertModule(title: R.Strings.authorization_triple_error.localized(),
                                           message: R.Strings.authorization_repeat.localized(),
                                           actions: [alertAction]
                )
                view?.showChild(module: module)
            }
        }
        
        let onPincodeChangedWithSuccess: ([Int], BaseView?) -> Void = { pincode, currentView in
            ServicesProvider.shared.authService.setPincode(pincode: pincode)
            guard let navigationController = (currentView as? UIViewController)?.navigationController,
                  let view = currentView
            else { return }
            TemplateHandler.handle(Constants.successAlert, in: view) { [weak navigationController] _ in
                navigationController?.replaceTopViewControllers(count: 2, with: [], animated: true)
            }
        }
        
        let context = ChangePincodeModuleContext(storage: PinCodeStorage(storage: StoreHelper.instance),
                                                 pinCodeManager: ServicesProvider.shared.authService,
                                                 onOldPincodeWrongValue: onOldPincodeWrongValue,
                                                 onPincodeChangedWithSuccess: onPincodeChangedWithSuccess)
        return context
    }
}

// MARK: - Constants
extension ChangePincodeModuleContext {
    private enum Constants {
        static let successAlert =  AlertTemplate(
            type: .middleCenterAlignAlert,
            isClosable: false,
            data: AlertTemplateData(
                icon: R.Strings.menu_change_pin_success_emoji.localized(),
                title: R.Strings.menu_change_pin_success_title.localized(),
                description: R.Strings.menu_change_pin_success_description.localized(),
                mainButton: AlertButtonModel(
                    title: R.Strings.menu_change_pin_thank.localized(),
                    icon: nil,
                    action: .ok),
                alternativeButton: nil)
        )
    }
}
