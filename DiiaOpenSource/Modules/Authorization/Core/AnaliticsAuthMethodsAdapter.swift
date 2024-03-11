import Foundation
import DiiaAuthorizationMethods

final class AnaliticsAuthMethodsAdapter: AnalyticsAuthMethodsHandler {
    func trackInitLoginByBankId(bankId: String) {
        AnalyticsProvider.track(event: AnalyticEvents.initLoginByBankId(bankId: bankId))
    }
}
