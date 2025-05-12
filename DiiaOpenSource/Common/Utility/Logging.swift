import Foundation
import DiiaNetwork

func log(_ items: Any...) {
    if EnvironmentVars.isInDebug {
        items.forEach { print($0) }
    }
}

struct PrintLogger: NetworkLoggerProtocol {
    func log(_ items: Any...) {
        if EnvironmentVars.isInDebug {
            items.forEach { print($0) }
        }
    }
}
