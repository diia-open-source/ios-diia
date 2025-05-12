import UIKit
import DiiaMVPModule
import DiiaUIComponents

protocol MenuView: BaseView {
    func clearStack()
    func addList(list: DSListViewModel)
    func addTransparentList(list: DSListViewModel)
    func share(url: String)
    func setTitle(title: String)
}

final class MenuViewController: UIViewController, Storyboarded {

    // MARK: - Properties
    var presenter: MenuAction!

    @IBOutlet weak private var topView: TopNavigationBigView!
    @IBOutlet weak private var stackView: UIStackView!
    @IBOutlet weak private var logoutButton: LoadingStateButton!
    @IBOutlet weak private var privacyLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        setupButton()
        setupPrivacyLabel()
        topView.configure(
            viewModel: .init(
                title: R.Strings.main_screen_menu.localized(),
                details: R.Strings.general_app_version.formattedLocalized(arguments: AppConstants.App.appVersion)
            )
        )
        presenter.configureView()
    }
    
    // MARK: - Configuration
    private func setupButton() {
        logoutButton.titleLabel?.font = FontBook.bigText
        logoutButton.contentEdgeInsets = Constants.buttonInsets
        logoutButton.setLoadingState(.enabled, withTitle: R.Strings.menu_logout.localized())
    }
    
    private func setupPrivacyLabel() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = Constants.lineHeightMultiple
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: FontBook.statusFont,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .paragraphStyle: paragraphStyle
        ]
        
        privacyLabel.attributedText = NSAttributedString(string: R.Strings.authorization_personal_data_message.localized(), attributes: attributes)
        
        let personalDataTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPersonalDataMessage))
        privacyLabel.addGestureRecognizer(personalDataTapRecognizer)
        privacyLabel.isUserInteractionEnabled = true
    }
    
    // MARK: - Private Methods
    @IBAction private func logoutButtonTapped() {
        showLogoutAlert()
    }
    
    @objc private func showPersonalDataMessage() {
        presenter.showPersonalDataMessage()
    }
}

// MARK: - View logic
extension MenuViewController: MenuView {
    func clearStack() {
        stackView.safelyRemoveArrangedSubviews()
    }
    
    func addList(list: DSListViewModel) {
        let view = DSWhiteColoredListView()
        view.configure(viewModel: list)
        stackView.addArrangedSubview(view)
    }
    
    func addTransparentList(list: DSListViewModel) {
        let view = DSTransparentListView()
        view.configure(viewModel: list)
        stackView.addArrangedSubview(view)
    }
    
    func share(url: String) {
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
    
    func setTitle(title: String) {
        self.title = title
        topView.configure(
            viewModel: .init(
                title: title,
                details: R.Strings.general_app_version.formattedLocalized(arguments: AppConstants.App.appVersion)
            )
        )
    }
    
    func showLogoutAlert() {
        let logoutAlertAction = AlertAction(title: R.Strings.menu_logout.localized(),
                                            type: .destructive,
                                            callback: { [weak self] in
                                                self?.presenter.logout()
                                            })
        let cancelAlertAction = AlertAction(title: R.Strings.menu_logout_cancel.localized(),
                                            type: .normal,
                                            callback: {}
        )
        let module = CustomAlertModule(title: R.Strings.menu_logout_title.localized(),
                                       message: R.Strings.menu_logout_message.localized(),
                                       actions: [logoutAlertAction, cancelAlertAction])
        self.showChild(module: module)
    }
}

extension MenuViewController {
    private enum Constants {
        static let buttonInsets = UIEdgeInsets.init(top: 0, left: 62, bottom: 0, right: 62)
        static let lineHeightMultiple: CGFloat = 1.25
    }
}
