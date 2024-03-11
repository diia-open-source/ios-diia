import UIKit
import DiiaMVPModule

final class DocumentsStackReorderingModule: BaseModule {
    private let view: DocumentsStackReorderingViewController
    private let presenter: DocumentsStackReorderingPresenter
    
    init(docType: DocType) {
        view = DocumentsStackReorderingViewController()
        presenter = DocumentsStackReorderingPresenter(view: view, docType: docType)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
