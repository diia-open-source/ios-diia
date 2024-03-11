import Foundation

class SwitchIconedViewModel: NSObject {
    let title: String
    let iconName: String
    @objc dynamic var isOn: Bool {
        didSet {
            onSwitch(isOn)
        }
    }
    private let onSwitch: (Bool) -> Void
    
    init(title: String,
         iconName: String,
         isOn: Bool,
         onSwitch: @escaping (Bool) -> Void) {
        self.title = title
        self.iconName = iconName
        self.isOn = isOn
        self.onSwitch = onSwitch
    }
}
