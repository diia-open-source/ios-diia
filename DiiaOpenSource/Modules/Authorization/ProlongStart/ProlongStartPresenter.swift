import UIKit
import DiiaMVPModule
import DiiaCommonServices
import DiiaCommonTypes
import DiiaAuthorization

protocol ProlongStartAction: BasePresenter {
    func identifyClicked()
}

final class ProlongStartPresenter {
    
    // MARK: - Properties
    unowned var view: ProlongStartView
    private let apiClient: AuthorizationApiClient
    private let completionHandler: Callback
    
    private var didRetry = false
    
    private let verificationService = ServicesProvider.shared.verificationService

    // MARK: - Init
    init(
        view: ProlongStartView,
        apiClient: AuthorizationApiClient,
        completionHandler: @escaping Callback
    ) {
        self.view = view
        self.apiClient = apiClient
        self.completionHandler = completionHandler
    }
    
    // MARK: - Public Methods
    func configureView() {
        
    }
}

// MARK: - ProlongStartAction
extension ProlongStartPresenter: ProlongStartAction {
    func identifyClicked() {
        verificationService.verifyUser(for: VerificationFlow.prolong, in: view) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let processId):
                self.prolong(processId: processId)
            case .canceled:
                self.view.closeToView(view: self.view, animated: true)
            case .failure, .close:
                break
            }
        }
    }
}

// MARK: - Identification methods
private extension ProlongStartPresenter {
    func prolong(processId: String) {
        ServicesProvider.shared.authService.prolong(in: view, processId: processId) { [weak self] error in
            guard let error = error else {
                self?.view.close()
                self?.completionHandler()
                return
            }
            switch error {
            case .nsUrlErrorDomain(_, let statusCode), .wrongStatusCode(_, let statusCode, _):
                if statusCode == AppConstants.HttpCode.unauthorized {
                    ServicesProvider.shared.authService.logout()
                    self?.completionHandler()
                    return
                }
            default:
                break
            }
            self?.showError(error: GeneralError(networkError: error), in: self?.view, retryAction: { [weak self] in
                self?.prolong(processId: processId)
            })
        }
    }
    
    func showError(error: GeneralError, in view: BaseView?, retryAction: @escaping Callback) {
        guard let view = view else { return }
        GeneralErrorsHandler.process(error: error, with: retryAction, didRetry: false, in: view, notClosable: true)
    }
}
