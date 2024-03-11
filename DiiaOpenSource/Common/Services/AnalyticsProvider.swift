import Foundation
import FirebaseAnalytics
import FirebaseCrashlytics

// MARK: - AnalyticsProvider
struct AnalyticsProvider {
    static func track(event: AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
        if EnvironmentVars.isInDebug {  log("Successfuly tracked \(event.name)") }
    }
}

// MARK: - AnalyticsEvents
struct AnalyticsEvent {
    let name: String
    let parameters: [String: String]
}

enum AnalyticsResult: String {
    case success
    case fail
}

enum AnalyticEvents {
    
    // MARK: - Network events
    static func initApiCall(action: String) -> AnalyticsEvent {
        return AnalyticsEvent(name: "NETWORK_INIT_API_CALL",
                              parameters: ["ACTION": action])
    }
    
    static func resultApiCall(action: String, result: AnalyticsResult, extraData: String?) -> AnalyticsEvent {
        return AnalyticsEvent(name: "NETWORK_RESULT_API_CALL",
                              parameters: [
                                "ACTION": action,
                                "RESULT": result.rawValue,
                                "EXTRA_DATA": extraData ?? ""
                              ])
    }
    
    // MARK: - Login
    static func initLoginByBankId(bankId: String) -> AnalyticsEvent {
        return AnalyticsEvent(name: "INIT_LOGIN_BY_BANK_ID", parameters: ["BANK_ID": bankId])
    }
    
    static func resultLoginByBankId(bankId: String, result: AnalyticsResult, extraData: String?) -> AnalyticsEvent {
        return AnalyticsEvent(name: "RESULT_LOGIN_BY_BANK_ID",
                              parameters: [
                                "BANK_ID": bankId,
                                "RESULT": result.rawValue,
                                "EXTRA_DATA": extraData ?? ""
                              ])
    }
}

// MARK: - NetworkActionKey
enum NetworkActionKey: String {
    case shareDriverLicense
    case getDocs
    case checkDocument
    case sendDocumentsOrder
    case sendStackOrder
}
