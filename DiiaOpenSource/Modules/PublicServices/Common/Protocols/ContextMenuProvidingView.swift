import UIKit
import DiiaMVPModule

protocol ContextMenuProvidingView: BaseView {
    var contextButton: UIButton! { get }
    func setContextMenuAvailable(isAvailable: Bool)
}

extension ContextMenuProvidingView {
    func setContextMenuAvailable(isAvailable: Bool) {
        contextButton.isHidden = !isAvailable
    }
}
