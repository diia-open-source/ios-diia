import Foundation
import DiiaAuthorizationPinCode

struct PinCodeStorage: PinCodeStorageProtocol {
    let storage: StoreHelper
    
    func getIsBiometryEnabled() -> Bool? {
        return storage.getValue(forKey: .isBiometryEnabled)
    }
    
    func getIncorrectPincodeAttemptsCount(flow: EnterPinCodeFlow) -> Int? {
        switch flow {
        case .auth:
            return storage.getValue(forKey: .incorrectPincodeCount)
        case .diiaId:
            return nil
        }
    }
    
    func saveIncorrectPincodeAttemptsCount(_ value: Int, flow: EnterPinCodeFlow) {
        switch flow {
        case .auth:
            storage.save(value, type: Int.self, forKey: .incorrectPincodeCount)
        case .diiaId:
            break
        }
    }
}
