import Foundation
import DiiaCommonTypes
import DiiaCommonServices

class DiiaIdSigner: NSObject, DiiaIdSignerProtocol {
    weak var delegate: DiiaSigningDelegate?
    
    func checkSignaturesState() {
        delegate?.onSigningStateChanged(state: .signingNotAvailable)
    }
    
    func setSignatureIdentifiers(_ signIdentifiers: [DiiaIdIdentifier]) {
        
    }
    
    func sign(flow: DiiaIdSigningFlow, verificationFlow: VerificationFlowProtocol) {
        delegate?.onSigningStateChanged(state: .template(template: Constants.notImplementedAlert))
    }
    
    func sign(verificationFlow: VerificationFlowProtocol) {
        sign(flow: .default, verificationFlow: verificationFlow)
    }
    
    func hardCreateAndSign(flow: DiiaIdSigningFlow, verificationFlow: VerificationFlowProtocol) {
        sign(flow: .default, verificationFlow: verificationFlow)
    }
    
    func createSignature(completion: @escaping (Bool) -> Void) {
        delegate?.onSigningStateChanged(state: .template(template: Constants.notImplementedAlert))
        completion(false)
    }
    
    func reset() {
        
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
