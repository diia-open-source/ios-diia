import UIKit
import ReactiveKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices
import DiiaAuthorization
import DiiaAuthorizationPinCode
import DiiaAuthorizationMethods

protocol StartAuthorizationAction: BasePresenter {
    func showPersonalDataProcessing()
    func viewWillAppear()
}

final class StartAuthorizationPresenter: StartAuthorizationAction {
    
    unowned var view: StartAuthorizationView
    private let apiClient: AuthorizationApiClient
    private let authFlow: AuthFlow
    private let storeHelper: StoreHelperProtocol = StoreHelper.instance
    private let bag = DisposeBag()

    private var checkmarks: [CheckmarkViewModel] = []
    private var processId: String?

    // MARK: - Init
    init(view: StartAuthorizationView, authApiClient: AuthorizationApiClient) {
        self.view = view
        self.apiClient = authApiClient
        self.authFlow = .login
    }

    // MARK: - Public Methods
    func configureView() {
        storeHelper.save(true, type: Bool.self, forKey: .hasAppBeenLaunchedBefore)
        setupAgreement()
    }

    func viewWillAppear() {
        if ServicesProvider.shared.authService.isAuthorizingByDeeplink {
            return
        }
        getAuthMethods()
    }

    func showPersonalDataProcessing() {
        CommunicationHelper.url(urlString: Constants.personalDataProcessingUrl)
    }
    
    // MARK: - API Methods
    private func getAuthMethods() {
        view.setLoadingState(.loading)
        apiClient
            .verificationAuthMethods(flow: VerificationFlow.authorization, processId: nil)
            .observe { [weak self, weak view] signal in
                guard let self = self, let view = view else { return }
                switch signal {
                case .next(let response):
                    self.processId = response.processId
                    self.processAuthMethods(response)
                    view.setLoadingState(.ready)
                case .failed(let error):
                    GeneralErrorsHandler.process(
                        error: .init(networkError: error),
                        with: { [weak self] in
                            guard let self = self else { return }
                            self.getAuthMethods()
                        },
                        didRetry: false,
                        in: view,
                        notClosable: true)
                default:
                    break
                }
            }.dispose(in: bag)
    }
    
    private func login(processId: String) {
        ServicesProvider.shared.authService.userLogin(in: view, processId: processId) { [weak self] error in
            if error == nil {
                self?.createPincode()
            } else {
                self?.getAuthMethods()
            }
        }
    }
    
    // MARK: - Private methods
    private func processAuthMethods(_ model: VerificationAuthMethodsResponse) {
        if let template = model.template {
            handleTemplate(template)
            return
        }

        guard var authMethods = model.authMethods else { return }
        authMethods.removeAll(where: { $0 != .bankid })
        configureAuthState()

        let authMethodItems = authMethods.map {
            let authMethod = $0.toAuthMethod()
            let viewModel = DSListItemViewModel(
                leftBigIcon: authMethod.icon,
                title: authMethod.label ?? "",
                onClick: { [weak self] in
                    self?.performAction(for: authMethod)
                }
            )
            viewModel.accessibilityLabel = authMethod.accessibilityLabel
            return viewModel
        }
        view.setAuthMethods(with: DSListViewModel(
            title: R.Strings.authorization_methods_title.localized(),
            items: authMethodItems)
        )
    }

    private func performAction(for authMethod: AuthMethod) {
        ServicesProvider.shared.authService.setProcessId(processId: self.processId)

        switch authMethod {
        case .bankId:
            identifyWithBankId()
        default:
            return
        }
    }

    private func configureAuthState() {
        ServicesProvider.shared.authService.setUserAuthorizationFlow(.login(completionHandler: { [weak self] _, action in
            self?.onVerificationFinish(action: action)
        }))
    }

    private func onVerificationFinish(action: AlertTemplateAction?) {
        guard let action = action else { return }

        switch action {
        case .ok, .pinCreation, .inputPin, .getToken, .prolong:
            guard let processId = ServicesProvider.shared.authService.getProcessId() else { return }
            self.login(processId: processId)
        default:
            break
        }
    }

    private func setupAgreement() {
        self.checkmarks = [
            CheckmarkViewModel(
                text: R.Strings.authorization_data_processing_agreement.localized(),
                isChecked: true,
                componentId: Constants.checkmarkComponentId)
        ]
        let viewModel = BorderedCheckmarksViewModel(checkmarks: self.checkmarks)
        viewModel.onClick = { [weak self] in
            guard let self = self else { return }
            let isAvailable = self.checkmarks.contains(where: { $0.isChecked })
            self.view.setAvailability(isAvailable)
        }
        view.setCheckmarks(with: viewModel)
    }

    // MARK: - Navigation
    private func identifyWithBankId() {
        let module = SelectBankModule(context: .create(),
                                      onClose: { _ in },
                                      handledRedirectionHosts: BankIDIdentifyTask.handledRedirectionHosts,
                                      appShortVersion: AppConstants.App.appShortVersion)
        view.open(module: module)
    }

    private func createPincode() {
        view.open(module: StartAuthorizationPresenter.userLoginSuccessModule())
    }

    // MARK: - Handlers
    private func handleTemplate(_ alert: AlertTemplate) {
        TemplateHandler.handle(alert, in: view) { action in
            switch action {
            case .logout:
                ServicesProvider.shared.authService.logout()
            default:
                return
            }
        }
    }
}

// MARK: - Constants
extension StartAuthorizationPresenter {
    private enum Constants {
        static let personalDataProcessingUrl = "https://diia.gov.ua/app_policy"
        static let checkmarkComponentId = "checkbox_conditions_auth"
    }
}

extension StartAuthorizationPresenter {
    /// completion handler wiith app level specific code for using after successfull authorization. Reused in Authorization Core
    static func userLoginSuccessModule() -> CreatePinCodeModule {
        return CreatePinCodeModule(
            viewModel: PinCodeViewModel(
                pinCodeLength: AppConstants.App.defaultPinCodeLength,
                createDetails: R.Strings.authorization_new_pin_details.localized(),
                repeatDetails: R.Strings.authorization_repeat_pin_details.localized(),
                authFlow: .login,
                completionHandler: { (pincode, view) in
                    ServicesProvider.shared.authService.setPincode(pincode: pincode)
                    switch BiometryHelper.biometricType() {
                    case .none:
                        AppRouter.instance.open(module: MainTabBarModule(), needPincode: false, asRoot: true)
                        AppRouter.instance.didFinishStartingWithPincode = true
                    default:
                        StoreHelper.instance.save(false, type: Bool.self, forKey: .isBiometryEnabled)
                        view.open(module: BiometryRequestModule(viewModel: .default(authFlow: .login)))
                    }
                }
            )
        )
    }
}
