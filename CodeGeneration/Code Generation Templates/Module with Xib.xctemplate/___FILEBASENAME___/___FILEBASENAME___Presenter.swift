//___FILEHEADER___

import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices

protocol ___VARIABLE_productName:identifier___Action: BasePresenter {
    func openContextMenu()
    func actionTapped()
}

final class ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName:identifier___Action {
    
    // MARK: - Properties
    unowned var view: ___VARIABLE_productName:identifier___View
    
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let flowCoordinator: FlowCoordinatorProtocol
    //    private let apiClient: APIClientProtocol
    private let bag = DisposeBag()
    
    // MARK: - Init
    init(
        view: ___VARIABLE_productName:identifier___View,
        flowCoordinator: FlowCoordinatorProtocol,
        contextMenuProvider: ContextMenuProviderProtocol
    ) {
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        //        self.apiClient = APIClient()
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setupHeader(contextMenuProvider: contextMenuProvider)
        fetchScreen()
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func actionTapped() {
        
    }
    
    // MARK: - Private Methods -
    private func processResponse(_ response: Model) {
        if let navigationPanel = response.navigationPanel {
            contextMenuProvider.setTitle(title: navigationPanel.header)
            contextMenuProvider.setContextMenu(items: navigationPanel.contextMenu)
            view.setupHeader(contextMenuProvider: contextMenuProvider)
        }
//        view.configure(model: response)
    }
    
    // MARK: - API
    private func fetchScreen() {
//        view.setLoadingState(.loading)
//        apiClient
//            .getStatus()
//            .observe { [weak self] event in
//                guard let self = self else { return }
//                switch event {
//                case .next(let response):
//                    self.processResponse(response)
//                    self.view.setLoadingState(.ready)
//                case .failed(let error):
//                    self.handleError(error: error) { [weak self] in
//                        self?.fetchStatus()
//                    }
//                default:
//                    return
//                }
//            }
//            .dispose(in: bag)
    }
    
    // MARK: - Handlers
    private func handleAlert(alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] action in
            guard let self = self else { return }
            switch action {
            default:
                self.flowCoordinator.restartFlow()
            }
        }
    }
    
    private func handleError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: retryAction,
            didRetry: false,
            in: view
        )
    }
}
