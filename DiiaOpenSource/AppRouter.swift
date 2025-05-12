import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes
import DiiaAuthorization
import DiiaAuthorizationPinCode

class AppRouter {

    private var window: UIWindow!
    private var navigationController: UINavigationController!
    private var tabBarController: MainTabRoutingProtocol?

    private var pincodeContainer: ContainerProtocol?
    private var pincodeView: UIViewController?
    private var defferedAction: ((BaseView?) -> Void)?
    private var defferedSafeAction: ((BaseView?) -> Void)?

    var didFinishStarting: Bool = false {
        didSet {
            guard didFinishStarting else { return }
            self.defferedAction?(self.currentView())
            self.defferedAction = nil
        }
    }
    var didFinishStartingWithPincode: Bool = false {
        didSet {
            guard didFinishStartingWithPincode else { return }
            self.defferedSafeAction?(self.currentView())
            self.defferedSafeAction = nil
        }
    }
    private let storeHelper: StoreHelperProtocol = StoreHelper.instance

    static let instance = AppRouter()
    
    private init() {}
    
    func configure(window: UIWindow, navigationController: UINavigationController = BaseNavigationController()) {
        self.window = window
        navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController = navigationController
    }
    
    func start() {
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        self.didFinishStartingWithPincode = false
        self.didFinishStarting = false
        self.tabBarController = nil
        
        routeStart()
        didFinishStarting = true
    }
    
    /// Navigate to destination module or make it root in navigation. Start deffered action if needed
    /// - Parameters:
    ///   - module: Destination module
    ///   - needPincode: Define if user need authorization for this navigation
    ///   - asRoot: Define if destination module should be root controller in navigation. If true rewrite tabBarController
    func open(module: BaseModule, needPincode: Bool, asRoot: Bool = false) {
        if needPincode {
            let completion: (Result<String, Error>) -> Void = { [weak self] result in
                guard let self = self, case .success = result else { return }
                
                self.forceOpen(module: module, asRoot: asRoot, completion: { [weak self] in
                    self?.pincodeView = nil
                    self?.didFinishStartingWithPincode = true
                })
            }
            let pincodeView = EnterPinCodeModule(
                context: EnterPinCodeModuleContext.create(flow: .auth, completionHandler: completion),
                flow: .auth,
                viewModel: .auth
            ).viewController()
            self.pincodeView = pincodeView
            navigationController.pushViewController(pincodeView, animated: true)
            return
        } else {
            forceOpen(module: module, asRoot: asRoot, completion: nil)
        }
    }
    
    /// Returns current visible view
    func currentView() -> BaseView? {
        return window.visibleViewController as? BaseView
    }
    
    /// Shows pincode over currentModule
    func showPincode() {
        if pincodeView != nil || pincodeContainer != nil { return }
        didFinishStartingWithPincode = false
        let completion: (Result<String, Error>) -> Void = { [weak self] result in
            guard let self = self, case .success = result else { return }
            self.pincodeContainer?.close()
            self.pincodeContainer = nil
            self.didFinishStartingWithPincode = true
        }
        let module = EnterPinCodeInContainerModule(context: EnterPinCodeModuleContext.create(flow: .auth, completionHandler: completion),
                                                   flow: .auth,
                                                   viewModel: .auth)
        currentView()?.showChild(module: module)
        pincodeContainer = module.viewController() as? ChildContainerViewController
    }
    
    /// Perform navigation action with currentView if route start processing was finished. If not, save it and process after finishing
    /// - Parameters:
    ///   - action: Navigation callback with view parameter which is currentView of AppRouter
    ///   - needPincode: Define if user need authorization for this navigation
    func performOrDefer(action: @escaping ((BaseView?) -> Void), needPincode: Bool = false) {
        if didFinishStarting
            && (!needPincode || didFinishStartingWithPincode) {
            action(currentView())
        } else if !needPincode {
            defferedAction = action
        } else {
            defferedSafeAction = action
        }
    }
    
    /// Pops to Root tab controller if it exists
    /// - Parameter action: Action for processing in tab controller after popping
    func popToTab(with action: MainTabAction) {
        if let tabController = self.tabBarController {
            navigationController.popToViewController(tabController, animated: true)
            tabController.processAction(action: action)
        }
    }
    
    // MARK: - Private
    private func routeStart() {
        func preparePinCodeModule(_ authFlow: AuthFlow) -> CreatePinCodeModule {
            return CreatePinCodeModule(
                    viewModel: PinCodeViewModel(
                    pinCodeLength: AppConstants.App.defaultPinCodeLength,
                    createDetails: R.Strings.authorization_new_pin_details.localized(),
                    repeatDetails: R.Strings.authorization_repeat_pin_details.localized(),
                    authFlow: authFlow,
                    completionHandler: { (pincode, view) in
                        ServicesProvider.shared.authService.setPincode(pincode: pincode)
                        switch BiometryHelper.biometricType() {
                        case .none:
                            AppRouter.instance.open(module: MainTabBarModule(), needPincode: false, asRoot: true)
                            AppRouter.instance.didFinishStartingWithPincode = true
                        default:
                            self.storeHelper.save(false, type: Bool.self, forKey: .isBiometryEnabled)
                            view.open(module: BiometryRequestModule(viewModel: .default(authFlow: authFlow)))
                        }
                    }
                )
            )
        }
        switch ServicesProvider.shared.authService.authState {
        case .userAuth:
            StartScenarioService().beginLoginScenarios()
            if ServicesProvider.shared.authService.havePincode() {
                open(module: MainTabBarModule(), needPincode: true, asRoot: true)
            } else {
                open(module: preparePinCodeModule(.login), needPincode: false)
            }
        case .notAuthorized, .serviceAuth:
            open(module: StartAuthorizationModule(), needPincode: false, asRoot: true)
        }
    }
    
    private func forceOpen(module: BaseModule, asRoot: Bool, completion: Callback?) {
        if asRoot {
            tabBarController = module.viewController() as? MainTabRoutingProtocol
            navigationController.setViewControllers([module.viewController()], animated: true, completion: completion)
        } else {
            self.navigationController.pushViewController(module.viewController(), animated: true, completion: completion)
        }
    }
}

extension AppRouter: AppRouterProtocol {}
