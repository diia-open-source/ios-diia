import Foundation
import DiiaMVPModule
import DiiaAuthorization
import DiiaAuthorizationMethods
import DiiaNetwork

extension BankIDAuthorizationNetworkContext {
    static func create() -> BankIDAuthorizationNetworkContext {
        .init(session: NetworkConfiguration.default.sessionWithoutInterceptor,
              host: EnvironmentVars.apiHost,
              headers: ["App-Version": AppConstants.App.appVersion,
                        "Platform-Type": AppConstants.App.platform,
                        "Platform-Version": AppConstants.App.iOSVersion,
                        "mobile_uid": AppConstants.App.mobileUID,
                        "User-Agent": AppConstants.App.userAgent],
              token: { ServicesProvider.shared.authService.token ?? "" }
        )

    }
}

extension BankIDAuthorizationContext {
    static func create() -> BankIDAuthorizationContext {
        .init(network: .create(),
              authService: ServicesProvider.shared.authService,
              authErrorRouter: UserAuthorizationErrorRouter(),
              analyticsHandler: AnaliticsAuthMethodsAdapter())
    }
}

final class BankIDIdentifyTask: IdentifyTaskPerformer {
    
    func identify(with input: UserIdentificationInput) {
        guard let view = input.initialView else { return }

        let module = SelectBankModule(context: .create(),
                                      onClose: input.onCloseCallback,
                                      handledRedirectionHosts: BankIDIdentifyTask.handledRedirectionHosts,
                                      appShortVersion: AppConstants.App.appShortVersion)
        view.open(module: module)
    }
    
    static let handledRedirectionHosts = [
        "api2oss.diia.gov.ua"
    ]
}
