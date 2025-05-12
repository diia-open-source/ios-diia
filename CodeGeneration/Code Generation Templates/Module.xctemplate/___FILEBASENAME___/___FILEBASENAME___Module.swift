//___FILEHEADER___

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class ___FILEBASENAMEASIDENTIFIER___: BaseModule {
    private let view: ConstructorViewController
    private let presenter: ___VARIABLE_productName:identifier___Presenter

    init(
        contextMenuProvider: ContextMenuProviderProtocol,
        flowCoordinator: FlowCoordinatorProtocol
    ) {
        view = ConstructorViewController()
        presenter = ___VARIABLE_productName:identifier___Presenter(
            view: view,
            flowCoordinator: flowCoordinator,
            contextMenuProvider: contextMenuProvider
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
