import Foundation
import DiiaNetwork

extension CommonService {

    var host: String {
        return EnvironmentVars.apiHost
    }

    var timeoutInterval: TimeInterval {
        return 30
    }
    
    var headers: [String: String]? {
        return ["App-Version": AppConstants.App.appVersion,
                "Platform-Type": AppConstants.App.platform,
                "Platform-Version": AppConstants.App.iOSVersion,
                "mobile_uid": AppConstants.App.mobileUID,
                "User-Agent": AppConstants.App.userAgent]
    }
    
    var analyticsAdditionalParameters: String? {
        return nil
    }
}
