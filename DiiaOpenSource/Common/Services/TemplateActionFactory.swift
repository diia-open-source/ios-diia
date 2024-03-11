import Foundation
import DiiaCommonTypes
import DiiaAuthorization

struct TemplateActionFactory {
    static func refreshTemplateAction(with callback: @escaping Callback) -> (AlertTemplateAction) -> Void {
        return { action in
            switch action {
            case .authMethods:
                AppRouter.instance.currentView()?.present(
                    module: ProlongStartModule(completionHandler: callback)
                )
            case .logout:
                ServicesProvider.shared.authService.logout()
                callback()
            default:
                break
            }
        }
    }
}

struct RefreshTemplateActionProviderImpl: RefreshTemplateActionProvider {
    func refreshTemplateAction(with callback: @escaping Callback) -> (AlertTemplateAction) -> Void {
        return TemplateActionFactory.refreshTemplateAction(with: callback)
    }
}
