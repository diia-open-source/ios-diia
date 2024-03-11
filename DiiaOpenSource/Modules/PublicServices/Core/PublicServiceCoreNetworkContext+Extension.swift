import Foundation
import DiiaNetwork
import DiiaPublicServicesCore

extension PublicServiceCoreNetworkContext {
    static func create() -> PublicServiceCoreNetworkContext {
        .init(session: NetworkConfiguration.default.session,
              host: EnvironmentVars.apiHost,
              headers: ["App-Version": AppConstants.App.appVersion,
                        "Platform-Type": AppConstants.App.platform,
                        "Platform-Version": AppConstants.App.iOSVersion,
                        "mobile_uid": AppConstants.App.mobileUID,
                        "User-Agent": AppConstants.App.userAgent]
        )
    }

}
