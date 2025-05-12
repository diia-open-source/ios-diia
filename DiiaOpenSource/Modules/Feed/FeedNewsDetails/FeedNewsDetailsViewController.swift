
import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol FeedNewsDetailsView: BaseView {
    func setLoadingState(_ state: LoadingState)
    func configure(with model: DSConstructorModel)
    func share(url: String)
}

final class FeedNewsDetailsViewController: UIViewController {

	// MARK: - Outlets
    @IBOutlet private weak var contentLoadingView: ContentLoadingView!
    @IBOutlet private weak var topNavigationView: TopNavigationView!
    @IBOutlet private weak var bodyGroupStackView: UIStackView!
    
	// MARK: - Properties
	var presenter: FeedNewsDetailsAction!

	// MARK: - Init
	init() {
        super.init(nibName: FeedNewsDetailsViewController.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	// MARK: - Lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }

    private func initialSetup() {
        topNavigationView.setupOnClose { [weak self] in
            self?.closeModule(animated: true)
        }
        topNavigationView.setupOnContext(callback: nil)
    }
}

// MARK: - View logic
extension FeedNewsDetailsViewController: FeedNewsDetailsView {
    func configure(with model: DSConstructorModel) {
        if let topGroup = model.topGroup.compactMap({
            if let topGroup: DSTopGroupOrg = $0.parseValue(forKey: DSTopGroupViewBuilder.modelKey) {
                return topGroup
            }
            return nil
        }).first?.titleGroupMlc {
            topNavigationView.setupTitle(title: topGroup.heroText)
        }
        
        bodyGroupStackView.safelyRemoveArrangedSubviews()
        bodyGroupStackView.addArrangedSubviews(
            DSViewFabric.instance.bodyViews(
                for: model,
                eventHandler: { [weak self] event in
                    self?.presenter.handleEvent(event: event)
                }
            )
        )
    }
    
    func setLoadingState(_ state: LoadingState) {
        contentLoadingView.setLoadingState(state)
        bodyGroupStackView.isHidden = state == .loading
    }
    
    func share(url: String) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
}

// MARK: - Constants
extension FeedNewsDetailsViewController {
    private enum Constants { 
    }
}
