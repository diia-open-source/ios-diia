//___FILEHEADER___

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class ___FILEBASENAMEASIDENTIFIER___: BaseModule {
    private let view: ConstructorModalViewController
    private let presenter: ___VARIABLE_productName:identifier___Presenter

    init() {
        view = ConstructorModalViewController()
        presenter = ___VARIABLE_productName:identifier___Presenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return PresentedController(viewController: view)
    }
}
