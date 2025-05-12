
import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes
import DiiaCommonServices

protocol FeedNewsDetailsAction: BasePresenter {
    func handleEvent(event: ConstructorItemEvent)
}

final class FeedNewsDetailsPresenter: FeedNewsDetailsAction {

    // MARK: - Properties
    unowned var view: FeedNewsDetailsView

    private let apiClient: FeedAPIClientProtocol
    private let bag = DisposeBag()
    private var didRetry = false
    
    private let newsId: String
    private let errorCallback: Callback?
    
    // MARK: - Init
    init(view: FeedNewsDetailsView,
         newsId: String,
         errorCallback: Callback?) {
        self.view = view
        self.newsId = newsId
        self.errorCallback = errorCallback
        self.apiClient = FeedAPIClient()
    }
    
    // MARK: - Public Methods
    func configureView() {
        fetchDetails()
    }
    
    func handleEvent(event: ConstructorItemEvent) {
        switch event {
        default:
            if let parameters = event.actionParameters() {
                handleAction(actionModel: parameters)
            }
        }
    }
    
    func handleAction(actionModel: DSActionParameter) {
        switch actionModel.type {
        case Constants.shareAction:
            guard let urlString = actionModel.resource else { return }
            view.share(url: urlString)
        default:
            return
        }
    }
    
    // MARK: - API
    private func fetchDetails() {
        view.setLoadingState(.loading)
        apiClient.getNewsDetails(id: newsId).observe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(let response):
                self.processResponse(response)
                self.view.setLoadingState(.ready)
            case .failed(let error):
                self.handleError(
                    error: error,
                    retryAction: { [weak self] in
                        self?.fetchDetails()
                    })
            default:
                return
            }
        }.dispose(in: bag)
    }
    
    // MARK: - Private Methods
    private func processResponse(_ response: DSConstructorModel) {
        if let alert = response.template {
            handleTemplate(alert)
        }
        view.configure(with: response)
    }
    
    // MARK: - Handlers
    private func handleTemplate(_ alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] action in
            switch action {
            case .back:
                self?.errorCallback?()
                self?.view.closeModule(animated: true)
            default:
                return
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
extension FeedNewsDetailsPresenter {
    private enum Constants {
        static let shareAction = "share"
    }
}
