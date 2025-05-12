
import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

protocol FeedView: BaseView {
    func setLoadingState(_ state: LoadingState)
    func configure(with model: DSConstructorModel)
    func isVisible() -> Bool
    func setTickerText(_ text: String?)
}

final class FeedViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var contentView: ContentLoadingView!
    @IBOutlet private weak var topNavigationView: TopNavigationBigView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bodyGroupStackView: UIStackView!
    @IBOutlet private weak var floatingTextLabel: FloatingTextLabel!
    
    // MARK: - Properties
    var presenter: FeedAction!
    
    // MARK: - Init
    init() {
        super.init(nibName: FeedViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.configureView()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.onViewDidAppear()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .clear
        floatingTextLabel.isHidden = true
    }
}

// MARK: - View logic
extension FeedViewController: FeedView {
    func configure(with model: DSConstructorModel) {
        let topGroupTitle = model.topGroup.compactMap { item in
            if let topGroup: DSTopGroupOrg = item.parseValue(forKey: "topGroupOrg") {
                return topGroup.titleGroupMlc
            }
            return nil
        }.first
        topNavigationView.isHidden = topGroupTitle == nil
        if let topGroup = topGroupTitle {
            topNavigationView.configure(
                viewModel: TopNavigationBigViewModel(title: topGroup.heroText)
            )
        }
        
        bodyGroupStackView.safelyRemoveArrangedSubviews()
        bodyGroupStackView.addArrangedSubviews(
            DSViewFabric.instance.bodyViews(for: model,
                                            eventHandler: { [weak self] event in
                                                self?.presenter.handleEvent(event: event)
                                            })
        )
    }
    
    func setTickerText(_ text: String?) {
        floatingTextLabel.reset()
        floatingTextLabel.isHidden = text == nil
        floatingTextLabel.labelText = text
        
        if text != nil {
            floatingTextLabel.animate()
        } else {
            floatingTextLabel.stopAnimation()
        }
    }
    
    func setLoadingState(_ state: LoadingState) {
        contentView.isHidden = state == .ready
        contentView.setLoadingState(state)
    }
    
    func isVisible() -> Bool {
        return view.window != nil
    }
}
