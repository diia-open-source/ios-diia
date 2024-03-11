import UIKit
import DiiaAuthorization

struct AuthorizationStateHandler: AuthorizationServiceStateHandler {
    
    private let appRouter: AppRouter
    private let storage: StoreHelper

    internal init(appRouter: AppRouter, storage: StoreHelper) {
        self.appRouter = appRouter
        self.storage = storage
    }

    func onLoginDidFinish() {
        StartScenarioService().beginLoginScenarios()
    }
    
    func onLogoutDidFinish() {
        storage.clearAllData()
        appRouter.start()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
