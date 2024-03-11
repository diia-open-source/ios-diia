import Foundation
import FirebaseCrashlytics
import DiiaCommonTypes
import DiiaNetwork

class CrashlyticsErrorRecorder: ResponseErrorHandler, ErrorReporter {
    func handleError(error: NSError) {
        Crashlytics.crashlytics().record(error: error)
    }

    func report(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
