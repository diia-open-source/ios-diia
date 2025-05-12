
import UIKit
import ReactiveKit
import DiiaNetwork
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonServices
import DiiaCommonTypes

protocol FeedAction: BasePresenter {
    func handleEvent(event: ConstructorItemEvent)
    func onViewWillAppear()
    func onViewDidAppear()
}

final class FeedPresenter: FeedAction {

	// MARK: - Properties
    unowned var view: FeedView
    
    private let apiClient: FeedAPIClientProtocol
    private let qrHelper: DiiaQRScannerHelper
    private let bag = DisposeBag()
    
    private var response: DSConstructorModel?
    private var isFetching = false
    private var needUpdates = true
    
    // MARK: - Init
    init(view: FeedView) {
        self.view = view
        self.apiClient = FeedAPIClient()
        self.qrHelper = DiiaQRScannerHelper(presentingView: view)
    }
    
    // MARK: - Public Methods
    func configureView() {
        setupObservations()
        let offlineModel = FeedOfflineModeConstructor.buildOfflineModel()
        view.configure(with: offlineModel)
    }
    
    func onViewWillAppear() {
        if needUpdates {
            fetchFeedScreen()
        }
    }
    
    func onViewDidAppear() {
        setNetworkStatus(isReachable: ReachabilityHelper.shared.isReachable())
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
        case Constants.newsAction:
            view.open(module: FeedNewsModule())
        case Constants.newsDetailsAction:
            guard let id = actionModel.resource else { return }
            view.open(module: FeedNewsDetailsModule(newsId: id))
        case Constants.qrAction:
            CameraAccessChecker.askCameraAccess { [weak self] (granted) in
                if granted, let delegate = self?.qrHelper {
                    self?.view.open(module: QRCodeScannerModule(delegate: delegate))
                }
            }
        default:
            break
        }
    }
    
    // MARK: - API
    @objc private func fetchFeedScreen() {
        if isFetching { return }
        isFetching = true
        view.setLoadingState(.loading)
        apiClient.getFeedScreen().observe { [weak self] event in
            guard let self else { return }
            switch event {
            case .next(let response):
                self.view.configure(with: response)
                self.setNetworkStatus(isReachable: true)
                self.needUpdates = false
                self.response = response
            case .failed(let error):
                if error != .noInternet {
                    self.handleError(
                        error: error,
                        retryAction: { [weak self] in
                            self?.fetchFeedScreen()
                        })
                }
            default:
                return
            }
            self.view.setLoadingState(.ready)
            self.isFetching = false
        }
        .dispose(in: bag)
    }
    
    // MARK: - Private Methods
    private func setupObservations() {
        ReachabilityHelper.shared
            .statusSignal
            .dropFirst(1)
            .observeNext { [weak self] isReachable in
                self?.setNetworkStatus(isReachable: isReachable)
                if isReachable {
                    self?.updateIfNeeded()
                }
            }
            .dispose(in: bag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateIfNeeded), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setOfflineMode() {
        setNetworkStatus(isReachable: false)
        guard response == nil else { return }

        let offlineModel = FeedOfflineModeConstructor.buildOfflineModel()
        view.configure(with: offlineModel)
    }
    
    private func setNetworkStatus(isReachable: Bool) {
        if isReachable, response == nil {
            fetchFeedScreen()
        }
        let text = isReachable ? nil : Constants.tickerText
        view.setTickerText(text)
    }
    
    @objc private func updateIfNeeded() {
        if view.isVisible() {
            fetchFeedScreen()
        } else {
            needUpdates = true
        }
    }
    
    // MARK: - Handlers
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
extension FeedPresenter {
    private enum Constants {
        static let messagesAction = "allMessages"
        static let newsAction = "allNews"
        static let newsDetailsAction = "news"
        static let qrAction = "qr"
        static let tickerText = Array(repeating: R.Strings.feed_ticker_label.localized(), count: 3).joined(separator: " • ")
    }
}
