import UIKit
import DiiaMVPModule

protocol QRCodeScannerAction: BasePresenter {
    func shouldProceed() -> Bool
    func proceed(code: String)
    func restart()
}

final class QRCodeScannerPresenter: QRCodeScannerAction {
    unowned var view: QRCodeScannerView
    private var isFinished = false
    private weak var delegate: QRScannerDelegate?
    
    init(view: QRCodeScannerView, delegate: QRScannerDelegate?) {
        self.view = view
        self.delegate = delegate
    }
    
    func configureView() {
        view.showQRError(message: nil)
    }
    
    func restart() {
        isFinished = false
    }
    
    func shouldProceed() -> Bool {
        return !isFinished
    }
    
    func proceed(code: String) {
        if isFinished { return }
        
        guard let result = delegate?.process(code: code, in: view) else { return }
        switch result {
        case .success:
            isFinished = true
            view.showQRError(message: nil)
        case .error(let message):
            view.showQRError(message: message)
        case .none:
            view.showQRError(message: nil)
        }
    }
}
