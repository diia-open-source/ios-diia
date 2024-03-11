import Foundation
import DiiaCommonTypes

protocol DeepLinkRouteBuilder {
    func canCreateRoute(with pathString: String) -> Bool
    func needAuth() -> Bool
    func create(pathString: String, queryParams: [DeeplinkQueryParameter: String]) -> RouterProtocol?
}
