import UIKit
import DiiaMVPModule
       
final class DocumentsReorderingModule: BaseModule {
    private let view: DocumentsReorderingViewController
    private let presenter: DocumentsReorderingPresenter
    
    init() {
        view = DocumentsReorderingViewController()
        presenter = DocumentsReorderingPresenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
