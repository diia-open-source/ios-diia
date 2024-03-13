import Foundation
import DiiaMVPModule

enum QRScannerResult {
    case none
    case error(message: String)
    case success
}

protocol QRScannerDelegate: NSObjectProtocol {
    func process(code: String, in view: BaseView?) -> QRScannerResult
}

class DiiaQRScannerHelper: NSObject, QRScannerDelegate {
    private weak var presentingView: BaseView?
    
    init(presentingView: BaseView?) {
        self.presentingView = presentingView
        super.init()
    }
    
    func process(code: String, in view: BaseView?) -> QRScannerResult {
        return processUrl(code: code, in: view)
    }
    
    private func processUrl(code: String, in view: BaseView?) -> QRScannerResult {
        guard
            let url = URL(string: code),
            url.host == Constants.diiaHost,
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return .error(message: R.Strings.qr_incorrect_code.localized())
        }
        
        guard let routerFabric = DeeplinksRoutersList.userRouters.first(where: { $0.canCreateRoute(with: components.path) }),
              let deeplinkRouter = routerFabric.create(pathString: components.path)
        else {
            return .error(message: R.Strings.qr_incorrect_code.localized())
        }
        
        if let view = view ?? presentingView {
            deeplinkRouter.route(in: view)
        }
        
        return .success
    }
}

// MARK: - Constants
extension DiiaQRScannerHelper {
    private enum Constants {
        static let diiaHost = "diia.app"
    }
}
