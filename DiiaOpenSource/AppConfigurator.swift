import UIKit
import FirebaseCore
import DiiaMVPModule
import DiiaNetwork
import DiiaCommonTypes
import DiiaCommonServices
import DiiaUIComponents

class AppConfigurator {
    static var storeHelper: StoreHelperProtocol = StoreHelper.instance

    static func configureApp() {
        if storeHelper.getValue(forKey: .hasAppBeenLaunchedBefore) != true {
            storeHelper.clearAllData()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }

        let mirgateService = MigrationService()
        mirgateService.migrateIfNeeded()
        
        FailableDecodableConfig.errorReporter = CrashlyticsErrorRecorder()

        // Adjusting DiiaNetwork.NetworkConfiguration must precede any work with packages
        // because they may rely on networking contex
        configureNetwork()
        
        FontBook.mainFont = AppMainFont()
        FontBook.headingFont = AppHeadingFont()
        UIComponentsConfiguration.shared.setup(imageNameProvider: DSImageNameResolver.instance, urlOpener: URLOpenerImpl())

        let deepLinkManager = DeepLinkManager()
        deepLinkManager.appRouter = AppRouter.instance
        let routingHandler = RoutingHandler(appRouter: AppRouter.instance)
        TemplateHandler.setup(context: .init(router: routingHandler,
                                             deepLink: deepLinkManager,
                                             communicationHelper: URLOpenerImpl()))
        
        FirebaseApp.configure()
    }

    static private func configureNetwork() {
        let networkConfigurator = NetworkConfiguration.default
        networkConfigurator.set(serverTrustPolicies: networkConfigurator.activeServerTrustPolicies())
        networkConfigurator.set(interceptor: AuthorizationInterceptor())
        if EnvironmentVars.isInDebug {
            networkConfigurator.set(logger: EnvironmentVars.logger)
        }
        networkConfigurator.set(httpStatusCodeHandler: HTTPStatusCodeAdapter())
        networkConfigurator.set(jsonDecoderConfig: JSONDecoderConfig())
        networkConfigurator.set(responseErrorHandler: CrashlyticsErrorRecorder())
        networkConfigurator.set(analyticsHandler: AnaliticsNetworkAdapter())
    }
}

class RoutingHandler: RoutingHandlerProtocol {
    private let appRouter: AppRouter

    internal init(appRouter: AppRouter) {
        self.appRouter = appRouter
    }

    func performPresenting(action: @escaping (BaseView?) -> Void) {
        appRouter.performOrDefer(action: action, needPincode: false)
    }
    func popToPublicServices() {
        appRouter.popToTab(with: .publicService)
    }
    
    func popToFeed() {
        appRouter.popToTab(with: .feed)
    }
    
    func popToDocuments() {
        appRouter.popToTab(with: .documents(type: nil))
    }
}

