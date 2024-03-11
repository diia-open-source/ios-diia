import Foundation
import DiiaAuthorization

final class ServicesProvider {
    static var shared: ServicesProvider = ServicesProvider()

    lazy var documentsLoader: DocumentsLoader = DocumentsLoader(storage: StoreHelper.instance,
                                                                apiClient: DocumentsAPIClient(),
                                                                orderService: DocumentReorderingService.shared)

    let authService: AuthorizationService = .init(context: .create())

    var verificationService: VerificationService {
        VerificationService(authorizationService: self.authService,
                            network: .create(),
                            userIdentifyHandlers: .userIdentifyHandlers)
    }

    private init() {
    }
}
