import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import DiiaCommonServices

class PaymentManager: NSObject, PaymentManagerProtocol {
    func startPayment(_ paymentRequest: PaymentRequestModel, in view: BaseView, callback: @escaping (AlertTemplateAction) -> Void) {
        TemplateHandler.handle(Constants.notImplementedAlert, in: view, callback: callback)
    }
    
    private enum Constants {
        static let notImplementedAlert = AlertTemplate(
            type: .middleCenterAlignAlert,
            isClosable: false,
            data: .init(
                icon: nil,
                title: "Не опубліковано",
                description: "На жаль, поточна реалізація включає закриті партнерські бібліотеки, тому не може бути опублікованою. Можете імплементувати цей функціонал власними силами",
                mainButton: .init(title: "Ок", icon: nil, action: .cancel),
                alternativeButton: nil
            ))
    }
}
