
import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol FeedNewsView: BaseView {
    func setLoadingState(_ state: LoadingState)
    func configure(with model: DSConstructorModel)
    func updateNews(_ news: [DSHalvedCardViewModel])
}

final class FeedNewsViewController: UIViewController {

	// MARK: - Outlets
    @IBOutlet private weak var contentLoadingView: ContentLoadingView!
    @IBOutlet private weak var topNavigationView: TopNavigationBigView!
    @IBOutlet private weak var bodyGroupStackView: UIStackView!
    
	// MARK: - Properties
	var presenter: FeedNewsAction!

	// MARK: - Init
	init() {
        super.init(nibName: FeedNewsViewController.className, bundle: nil)
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
    
    // MARK: - Private Methods
    private func initialSetup() {
        topNavigationView.configure(
            viewModel: TopNavigationBigViewModel(
                title: "",
                backAction: { [weak self] in
                    self?.closeModule(animated: true)
            })
        )
    }
}

// MARK: - View logic
extension FeedNewsViewController: FeedNewsView {
    func configure(with model: DSConstructorModel) {
        if let topGroup = model.topGroup.compactMap({
            if let topGroup: DSTopGroupOrg = $0.parseValue(forKey: DSTopGroupViewBuilder.modelKey) {
                return topGroup
            }
            return nil
        }).first?.titleGroupMlc {
            topNavigationView.configure(
                viewModel: TopNavigationBigViewModel(
                    title: topGroup.heroText,
                    backAction: { [weak self] in
                        self?.closeModule(animated: true)
                })
            )
        }
    }
    
    func updateNews(_ news: [DSHalvedCardViewModel]) {
        bodyGroupStackView.safelyRemoveArrangedSubviews()
        
        let cards = news.map {
            let card = DSHalvedCardCell()
            card.configure(with: $0)
            card.withHeight(Constants.cardHeight)
            return BoxView(subview: card).withConstraints(insets: Constants.cardInsets)
        }
        bodyGroupStackView.addArrangedSubviews(cards)
    }
    
    func setLoadingState(_ state: LoadingState) {
        contentLoadingView.setLoadingState(state)
        bodyGroupStackView.isHidden = state == .loading
    }
}

// MARK: - Constants
extension FeedNewsViewController {
    private enum Constants {
        static let cardHeight: CGFloat = UIScreen.main.bounds.width * 0.51
        static let cardInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
}
