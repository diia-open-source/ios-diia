import UIKit

struct MobileUIDGenerator {
    private let storeHelper: StoreHelperProtocol = StoreHelper.instance

    func getMobileUID() -> String {
        if let mobileUID: String = storeHelper.getValue(forKey: .mobileUID) {
            return mobileUID
        }
        let mobileUID = UUID().uuidString
        storeHelper.save(mobileUID, type: String.self, forKey: .mobileUID)
        return mobileUID
    }
}
