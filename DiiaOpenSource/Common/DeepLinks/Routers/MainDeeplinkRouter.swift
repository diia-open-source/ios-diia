import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import DiiaAuthorization

struct MainDeeplinkRouteBuilder: DeepLinkRouteBuilder {
    func canCreateRoute(with pathString: String) -> Bool {
        return pathString == "/main"
    }
    
    func needAuth() -> Bool {
        return true
    }
    
    func create(pathString: String, queryParams: [DeeplinkQueryParameter: String]) -> RouterProtocol? {
        if canCreateRoute(with: pathString) { return MainDeeplinkRoute() }
        return nil
    }
}

struct MainDeeplinkRoute: RouterProtocol {
    func route(in view: BaseView) {
        ServicesProvider.shared.authService.authorize(in: view)
    }
}
