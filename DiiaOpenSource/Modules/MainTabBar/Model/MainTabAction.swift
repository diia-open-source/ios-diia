import Foundation

enum MainTabAction: Equatable {
    case feed
    case settings
    case publicService
    case documents(type: DocType?)
    
    static func == (lhs: MainTabAction, rhs: MainTabAction) -> Bool {
        switch (lhs, rhs) {
        case (.feed, .feed),
            (.settings, .settings),
            (.publicService, .publicService):
            return true
        case (let .documents(lValue), let .documents(rValue)):
            return lValue == rValue
        default:
            return false
        }
    }
}
