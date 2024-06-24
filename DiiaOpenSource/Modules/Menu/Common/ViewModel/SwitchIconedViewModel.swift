import Foundation
import UIKit

class SwitchIconedViewModel: NSObject {
    let title: String
    let icon: UIImage
    @objc dynamic var isOn: Bool {
        didSet {
            onSwitch(isOn)
        }
    }
    private let onSwitch: (Bool) -> Void
    
    init(title: String,
         icon: UIImage,
         isOn: Bool,
         onSwitch: @escaping (Bool) -> Void) {
        self.title = title
        self.icon = icon
        self.isOn = isOn
        self.onSwitch = onSwitch
    }
}
