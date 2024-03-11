import Foundation
import DiiaCommonServices

class DeepLinkManager {
    var appRouter: AppRouter?
    
    @discardableResult
    func parse(url: URL) -> Bool {
        guard
            let urlString = url
                .absoluteString
                .removingPercentEncoding?
                .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let newUrl = URL(string: urlString),
            let components = URLComponents(url: newUrl, resolvingAgainstBaseURL: true)
        else {
            return false
        }
        
        components.queryItems?.forEach { log($0) }
        
        var queryParams: [DeeplinkQueryParameter: String] = [:]
        components.queryItems?.forEach({ (queryItem) in
            if let linkType = DeeplinkQueryParameter(rawValue: queryItem.name) {
                queryParams[linkType] = queryItem.value
            }
        })
        
        guard let routerBuilder = DeeplinksRoutersList.userRouters.first(where: { $0.canCreateRoute(with: components.path) }),
              let deeplinkRouter = routerBuilder.create(pathString: components.path, queryParams: queryParams)
        else {
            return false
        }
        
        appRouter?.performOrDefer(
            action: { view in
                guard let view = view else { return }
                deeplinkRouter.route(in: view)
            },
            needPincode: routerBuilder.needAuth())
        
        return true
    }
}

extension DeepLinkManager: DeepLinkManagerProtocol { }
