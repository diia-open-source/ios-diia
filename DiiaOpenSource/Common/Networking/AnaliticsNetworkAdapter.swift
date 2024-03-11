import Foundation
import DiiaNetwork

class AnaliticsNetworkAdapter: AnalyticsNetworkHandler {
    func trackNetworkInitEvent(action: String) {
        AnalyticsProvider.track(event: AnalyticEvents.initApiCall(action: action))
    }
    
    /// Parameter `result` is the raw value of the internal AnalyticsNetworkResult enum from DiiaNetwork.
    /// Network cases from the app's AnalyticsResult have to match the package's AnalyticsNetworkResult.
    func trackNetworkResultEvent(action: String, result: String, extraData: String?) {
        AnalyticsProvider.track(event: AnalyticEvents.resultApiCall(action: action, result: .init(rawValue: result) ?? .fail, extraData: extraData))
    }
}
