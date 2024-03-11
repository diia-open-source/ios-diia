import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol StartAuthorizationView: BaseView {
    func setLoadingState(_ state: LoadingState)
    func setAuthMethods(with viewModel: DSListViewModel)
    func setCheckmarks(with viewModel: BorderedCheckmarksViewModel)
    func setAvailability(_ isAvailable: Bool)
}

final class StartAuthorizationViewController: UIViewController, Storyboarded {
    
    // MARK: - Outlets
    @IBOutlet private weak var loadingView: ContentLoadingView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var appVersion: UILabel!
    @IBOutlet private weak var authInfoLabel: UILabel!
    @IBOutlet private weak var readPleaseLabel: UILabel!
    @IBOutlet private weak var personalDataLabel: UILabel!
    @IBOutlet private weak var checkmarksView: BorderedCheckmarksView!
    @IBOutlet private weak var authMethodsListView: DSWhiteColoredListView!
    
    // MARK: - Properties
    var presenter: StartAuthorizationAction!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        setupFonts()
        setupTexts()
        setupRecognizers()
        setupAccessibility()
        scrollView.delegate = self
    }
    
    private func setupFonts() {
        titleLabel.font = FontBook.numbersHeadingFont
        appVersion.font = FontBook.usualFont
        authInfoLabel.font = FontBook.usualFont
        readPleaseLabel.font = FontBook.usualFont
    }
    
    private func setupTexts() {
        titleLabel.text = R.Strings.authorization_authorization.localized()
        appVersion.text = R.Strings.general_app_version.formattedLocalized(arguments: AppConstants.App.appVersion)
        appVersion.textColor = Constants.appVersionTextColor
        
        authInfoLabel.setTextWithCurrentAttributes(
            text: R.Strings.authorization_info.localized(),
            lineHeightMultiple: Constants.lineHeightMultiple
        )
        readPleaseLabel.setTextWithCurrentAttributes(
            text: R.Strings.authorization_read_please.localized(),
            lineHeightMultiple: Constants.lineHeightMultiple
        )
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.lineHeightMultiple
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontBook.usualFont,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle
        ]
        
        personalDataLabel.attributedText = NSAttributedString(string: R.Strings.authorization_personal_data_message.localized(), attributes: attributes)
    }
    
    private func setupRecognizers() {
        let personalDataTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPersonalDataMessage))
        personalDataLabel.addGestureRecognizer(personalDataTapRecognizer)
        personalDataLabel.isUserInteractionEnabled = true
    }
    
    override func canGoBack() -> Bool {
        return false
    }
    
    // MARK: - Actions
    @objc private func showPersonalDataMessage() {
        presenter.showPersonalDataProcessing()
    }
    
    // MARK: - Accessibility
    private func setupAccessibility() {
        titleLabel.accessibilityIdentifier = Constants.titleComponentId
        authInfoLabel.accessibilityIdentifier = Constants.textConditionsComponentId
        checkmarksView.accessibilityIdentifier = Constants.checkboxComponentId
        authMethodsListView.accessibilityIdentifier = Constants.methodsListComponentId
        
        personalDataLabel.accessibilityLabel = R.Strings.auth_accessibility_start_person_data.localized()
        personalDataLabel.accessibilityTraits = .link
        checkmarksView.isAccessibilityElement = true
        checkmarksView.accessibilityTraits = [.button, .selected]
        checkmarksView.accessibilityLabel = R.Strings.auth_accessibility_start_checkmark.localized()
    }
    
    private func updateCheckmarkAccessibility(isChecked: Bool) {
        checkmarksView.accessibilityTraits = isChecked ? .selected : .notEnabled
    }
}

// MARK: - View logic
extension StartAuthorizationViewController: StartAuthorizationView {
    func setLoadingState(_ state: DiiaUIComponents.LoadingState) {
        loadingView.setLoadingState(state)
        contentView.isHidden = state == .loading
    }
    
    func setAuthMethods(with viewModel: DSListViewModel) {
        contentView.isHidden = false
        authMethodsListView.configure(viewModel: viewModel)
    }
    
    func setCheckmarks(with viewModel: BorderedCheckmarksViewModel) {
        checkmarksView.configure(with: viewModel)
    }
    
    func setAvailability(_ isAvailable: Bool) {
        updateCheckmarkAccessibility(isChecked: isAvailable)
        authMethodsListView.subviews.forEach { $0.alpha = isAvailable ? Constants.activeAlpha : Constants.inactiveAlpha }
        authMethodsListView.isUserInteractionEnabled = isAvailable
    }
}

// MARK: - UIScrollViewDelegate
extension StartAuthorizationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = scrollView.frame.height <= scrollView.contentSize.height
    }
}

// MARK: - Constants
extension StartAuthorizationViewController {
    private enum Constants {
        static let lineHeightMultiple: CGFloat = 1.25
        static let activeAlpha: CGFloat = 1.0
        static let inactiveAlpha: CGFloat = 0.2
        static let appVersionTextColor = UIColor.black.withAlphaComponent(0.5)
        
        static let titleComponentId = "title_auth"
        static let textConditionsComponentId = "text_conditions_auth"
        static let checkboxComponentId = "checkbox_conditions_bordered_auth"
        static let methodsListComponentId = "methods_list_auth"
    }
}
