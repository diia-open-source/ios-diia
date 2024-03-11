import Foundation

func log(_ items: Any...) {
    if EnvironmentVars.isInDebug {
        items.forEach { print($0) }
    }
}
