import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol ProlongStartView: BaseView {
    func close()
}

final class ProlongStartViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var detailsLabel: UILabel!
    @IBOutlet private weak var actionButton: LoadingStateButton!

	// MARK: - Properties
	var presenter: ProlongStartAction!

	// MARK: - LifeCycle
	override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    private func initialSetup() {
        setupFonts()
        setupStaticContent()
        setupButton()
    }
    
    private func setupStaticContent() {
        titleLabel.text = R.Strings.user_identification_start_title.localized()
        detailsLabel.setTextWithCurrentAttributes(
            text: R.Strings.user_identification_start_details.localized(),
            lineHeightMultiple: Constants.detailsLineHeightMultiple
        )
    }
    
    private func setupFonts() {
        titleLabel.font = FontBook.numbersHeadingFont
        detailsLabel.font = FontBook.usualFont
    }
    
    private func setupButton() {
        actionButton.setLoadingState(.enabled, withTitle: R.Strings.general_confirm.localized())
        actionButton.titleLabel?.font = FontBook.bigText
        actionButton.contentEdgeInsets = Constants.buttonSolidInsets
    }
    
    // MARK: - Actions
    @IBAction private func actionButtonTapped() {
        presenter.identifyClicked()
    }
}

// MARK: - View logic
extension ProlongStartViewController: ProlongStartView {
    func close() {
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - Constants
extension ProlongStartViewController {
    private enum Constants {
        static let detailsLineHeightMultiple: CGFloat = 1.25
        
        static let buttonSolidInsets = UIEdgeInsets.init(top: 0, left: 32, bottom: 0, right: 32)
    }
}
