import UIKit
import DiiaCommonTypes
import DiiaUIComponents

class SettingsManager {
    
    static let instance = SettingsManager()
    
    private init() {}
    
    var storeHelper: StoreHelperProtocol = StoreHelper.instance
    
    func setBiometry(isAllowed: Bool) {
        storeHelper.save(isAllowed, type: Bool.self, forKey: .isBiometryEnabled)
    }
    
    func isBiometryAllowed() -> Bool {
        return storeHelper.getValue(forKey: .isBiometryEnabled) == true
    }
    
    func openSystemSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        onMainQueue {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
    }
}
