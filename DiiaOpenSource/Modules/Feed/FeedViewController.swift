import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol FeedView: BaseView {
    
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
    
    // MARK: - Private Methods
    private func initialSetup() {
        view.backgroundColor = .clear
        topNavigationView.configure(viewModel: TopNavigationBigViewModel(title: ""))
        floatingTextLabel.isHidden = true
    }
}

// MARK: - View logic
extension FeedViewController: FeedView {

}
