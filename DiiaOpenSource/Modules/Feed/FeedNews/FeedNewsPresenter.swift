
import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaCommonTypes
import DiiaCommonServices
import DiiaUIComponents

protocol FeedNewsAction: BasePresenter { }

final class FeedNewsPresenter: FeedNewsAction {

	// MARK: - Properties
    unowned var view: FeedNewsView

    private let apiClient: FeedAPIClientProtocol
    private let bag = DisposeBag()
    private var didRetry = false
    
    private var news: [DSHalvedCardViewModel] = []
    private var isFetching = false
    private var total: Int?
    
    // MARK: - Init
    init(view: FeedNewsView) {
        self.view = view
        self.apiClient = FeedAPIClient()
    }
    
    // MARK: - Public Methods
    func configureView() {
        fetchScreen()
    }
    
    // MARK: - API
    private func fetchScreen() {
        view.setLoadingState(.loading)
        apiClient.getFeedNewsScreen().observe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(let response):
                self.handleScreenResponse(response)
                self.fetchNews()
            case .failed(let error):
                self.handleError(
                    error: error,
                    retryAction: { [weak self] in
                        self?.fetchScreen()
                    })
            default:
                return
            }
        }.dispose(in: bag)
    }
    
    private func fetchNews() {
        if isFetching || (total ?? Int.max <= news.count) {
            return
        }
        
        let pagination: PaginationModel = PaginationModel(skip: news.count, limit: Constants.paginationLimit, search: nil)
        isFetching = true
        
        apiClient.getFeedNews(pagination: pagination).observe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(let response):
                self.handleNewsResponse(response)
                self.view.setLoadingState(.ready)
            case .failed(let error):
                self.handleError(
                    error: error,
                    retryAction: { [weak self] in
                        self?.fetchNews()
                    })
            default:
                return
            }
        }.dispose(in: bag)
    }
    
    // MARK: - Private Methods
    private func handleScreenResponse(_ response: DSConstructorModel) {
        if let alert = response.template {
            handleTemplate(alert)
        }
        view.configure(with: response)
    }
    
    private func handleNewsResponse(_ response: TemplatedResponse<FeedNewsResponse>) {
        switch response {
        case .data(let data):
            self.total = data.total
            let newsViewModels: [DSHalvedCardViewModel] = data.items.compactMap {
                guard let halvedCard = $0.halvedCardMlc else { return nil }
                let viewModel = DSHalvedCardViewModel(
                    id: halvedCard.action?.resource ?? "",
                    imageURL: halvedCard.image,
                    label: halvedCard.label,
                    title: halvedCard.title)
                viewModel.clickAction = { [weak self] in
                    self?.selectNews(viewModel)
                }
                return viewModel
            }
            news.append(contentsOf: newsViewModels)
            view.updateNews(newsViewModels)
        case .template(let alert):
            handleTemplate(alert)
        }
    }
    
    private func reloadNews() {
        news = []
        isFetching = false
        total = nil
        fetchScreen()
    }
    
    private func selectNews(_ viewModel: DSHalvedCardViewModel) {
        view.open(module: FeedNewsDetailsModule(
            newsId: viewModel.id,
            errorCallback: { [weak self] in
                self?.reloadNews()
            })
        )
    }
    
    // MARK: - Handlers
    private func handleTemplate(_ alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { [weak self] action in
            switch action {
            case .back:
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

    private func handleCriticalError(error: NetworkError, retryAction: @escaping Callback) {
        GeneralErrorsHandler.process(
            error: .init(networkError: error),
            with: { [weak self] in
                self?.didRetry = true
                retryAction()
            },
            didRetry: didRetry,
            in: view
        )
    }
}

// MARK: - Constants
extension FeedNewsPresenter {
    private enum Constants {
        static let paginationLimit = 10
    }
}
