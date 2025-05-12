//___FILEHEADER___

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class ___FILEBASENAMEASIDENTIFIER___: BaseModule {
    private let view: ConstructorViewController
    private let presenter: ___VARIABLE_productName:identifier___MainPresenter
    
    init(
        contextMenuProvider: ContextMenuProviderProtocol
    ) {
        view = ConstructorViewController()
        presenter = ___VARIABLE_productName:identifier___MainPresenter(
            view: view,
            contextMenuProvider: contextMenuProvider)
        view.presenter = presenter
    }
    
    func viewController() -> UIViewController {
        return view
    }
}
