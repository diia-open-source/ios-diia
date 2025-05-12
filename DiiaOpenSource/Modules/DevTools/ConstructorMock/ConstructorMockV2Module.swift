
import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents

final class ConstructorMockV2Module: BaseModule {
    private let view: ConstructorViewController
    private let presenter: ConstructorMockV2Presenter
    
    init(json: String? = nil, contextMenuProvider: ContextMenuProviderProtocol) {
        view = ConstructorViewController()
        presenter = ConstructorMockV2Presenter(view: view, json: json, contextMenuProvider: contextMenuProvider)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
