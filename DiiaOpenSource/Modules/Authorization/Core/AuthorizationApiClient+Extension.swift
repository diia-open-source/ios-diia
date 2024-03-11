import Foundation
import DiiaAuthorization

extension AuthorizationApiClient {
    static func create() -> AuthorizationApiClient {
        AuthorizationApiClient(context: .create(), token: { ServicesProvider.shared.authService.token ?? "" })
    }
}
