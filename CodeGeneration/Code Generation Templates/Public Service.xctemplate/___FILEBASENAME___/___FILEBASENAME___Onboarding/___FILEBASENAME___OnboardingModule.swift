//___FILEHEADER___

import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class ___FILEBASENAMEASIDENTIFIER___: BaseModule {
    private let view: ConstructorViewController
    private let presenter: ___VARIABLE_productName:identifier___OnboardingPresenter
    
    init(contextMenuProvider: ContextMenuProviderProtocol = BaseContextMenuProvider(publicService: .___VARIABLE_publicServiceName:identifier___)) {
        view = ConstructorViewController()
        presenter = ___VARIABLE_productName:identifier___OnboardingPresenter(
            view: view,
            flowCoordinator: PublicServiceFlowCoordinator(rootView: view),
            contextMenuProvider: contextMenuProvider
        )
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
