import UIKit
import DiiaCommonServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var router: AppRouter!
    private var stubImage: UIImageView!
    private let deeplinkManager = DeepLinkManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ReachabilityHelper.shared.startNetworkReachabilityObserver()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        router = AppRouter.instance
        router.configure(window: window)
        deeplinkManager.appRouter = router
        window.makeKeyAndVisible()
        
        // AppConfigurator.configureApp should be called before creating any apiClient with NetworkConfiguration.default.session in order to set the interceptor first
        AppConfigurator.configureApp()
        
        UIApplication.shared.registerForRemoteNotifications()
        
        window.rootViewController = SplashScreenModule(onFinish: { [weak self] in
            self?.router.start()
        }).viewController()
        
        return true
    }
    
    // MARK: - DeepLinks
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL
        else {
            return false
        }
        
        return deeplinkManager.parse(url: url)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        return deeplinkManager.parse(url: url)
    }
    
    // MARK: - LifeCycle
    func applicationWillResignActive(_ application: UIApplication) {
        if let window = window, stubImage == nil {
            stubImage = UIImageView(frame: window.frame)
            stubImage.image = R.image.light_background.image
        }
        stubImage.alpha = 0
        self.window?.addSubview(stubImage)
        self.window?.endEditing(true)
        UIView.animate(withDuration: 0.2, animations: { self.stubImage.alpha = 1 })
        if router.didFinishStarting {
            ServicesProvider.shared.authService.setLastPincodeDate(date: Date())
        }
        ScreenBrightnessHelper.shared.resetBrightness()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if stubImage != nil {
            stubImage.removeFromSuperview()
        }
        for window in application.windows {
            window.rootViewController?.beginAppearanceTransition(true, animated: false)
            window.rootViewController?.endAppearanceTransition()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        for window in application.windows {
            window.rootViewController?.beginAppearanceTransition(false, animated: false)
            window.rootViewController?.endAppearanceTransition()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if ServicesProvider.shared.authService.doesNeedPincode() {
            router.showPincode()
        }
    }
    
    // MARK: - Disable Third Party Keyboards
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        
        return true
    }
}
