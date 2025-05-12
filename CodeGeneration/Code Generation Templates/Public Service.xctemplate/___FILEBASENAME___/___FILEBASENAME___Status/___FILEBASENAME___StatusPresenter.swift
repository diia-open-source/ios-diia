//___FILEHEADER___

import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes
import DiiaCommonServices

final class ___FILEBASENAMEASIDENTIFIER___: ConstructorScreenPresenter {
    
    // MARK: - Properties
    unowned var view: ConstructorScreenViewProtocol
    
    private var contextMenuProvider: ContextMenuProviderProtocol
    private let apiClient: ___VARIABLE_productName:identifier___APIClientProtocol
    private let flowCoordinator: FlowCoordinatorProtocol
    private let bag = DisposeBag()
    
    private let applicationId: String
    
    // MARK: - Init
    init(
        applicationId: String,
        view: ConstructorScreenViewProtocol,
        flowCoordinator: FlowCoordinatorProtocol,
        contextMenuProvider: ContextMenuProviderProtocol,
        apiClient: ___VARIABLE_productName:identifier___APIClientProtocol = ___VARIABLE_productName:identifier___APIClient()
    ) {
        self.applicationId = applicationId
        self.view = view
        self.flowCoordinator = flowCoordinator
        self.contextMenuProvider = contextMenuProvider
        self.apiClient = apiClient
    }
    
    // MARK: - Public Methods
    func configureView() {
        fetchScreen()
    }
    
    func openContextMenu() {
        contextMenuProvider.openContextMenu(in: view)
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        switch event {
        case .inputChanged:
            view.inputFieldsWasUpdated()
        default:
            guard let action = event.actionParameters() else { return }
            actionTapped(action: action)
        }
    }
    
    // MARK: - Private Methods -
    private func actionTapped(action: DSActionParameter) {
        switch action.type {
        case Constants.backAction:
            view.closeModule(animated: true)
        default:
            log(String(describing: action.type))
        }
    }
    
    private func processResponse(_ response: DSConstructorModel) {
        updateContextMenu(topGroup: response.topGroup)
        view.configure(model: response)
        if let template = response.template {
            handleAlert(alert: template)
        }
    }
    
    private func updateContextMenu(topGroup: [AnyCodable]) {
        for item in topGroup {
            guard let topGroupOrg: DSTopGroupOrg = item.parseValue(forKey: "topGroupOrg"),
                  let navPanel = topGroupOrg.navigationPanelMlc
            else { continue }
            
            contextMenuProvider.setTitle(title: navPanel.label)
            contextMenuProvider.setContextMenu(items: navPanel.ellipseMenu)
            view.setHeader(headerContext: contextMenuProvider)
            return
        }
    }
    
    // MARK: - API Methods
    private func fetchScreen() {
        view.setLoadingState(.loading)
        apiClient
            .getStatusScreen(applicationId: applicationId)
            .observe { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .next(let response):
                    self.view.setLoadingState(.ready)
                    self.processResponse(response)
                case .failed(let error):
                    self.handleError(error: error) { [weak self] in
                        self?.fetchScreen()
                    }
                default:
                    return
                }
            }
            .dispose(in: bag)
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

// MARK: - Constants
private extension ___FILEBASENAMEASIDENTIFIER___ {
    enum Constants {
        static let backAction = "back"
    }
}
