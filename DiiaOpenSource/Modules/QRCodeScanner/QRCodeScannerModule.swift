import UIKit
import DiiaMVPModule

final class QRCodeScannerModule: BaseModule {
    private let view: QRCodeScannerViewController
    private let presenter: QRCodeScannerPresenter
    
    init(delegate: QRScannerDelegate? = nil) {
        view = QRCodeScannerViewController.storyboardInstantiate()
        presenter = QRCodeScannerPresenter(view: view, delegate: delegate)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
