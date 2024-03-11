import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaAuthorization
import DiiaUIComponents

struct UserAuthorizationErrorRouter: RouterExtendedProtocol {

    private var callback: Callback {{
        let module = HorizontalActionSheetModule(title: R.Strings.menu_support.localized(),
                                                 actions: CommunicationHelper.getCommunicationsActions())
        AppRouter.instance.currentView()?.showChild(module: module)
    }}

    var module: AuthorizationErrorModule {
        AuthorizationErrorModule(
            errorInfo: .userAuth(with: callback),
            mobileUID: { AppConstants.App.mobileUID },
            logout: { ServicesProvider.shared.authService.logout() }
        )
    }

    // MARK: - RouterProtocol
    func route(in view: BaseView) {
        view.open(module: module)
    }

    // MARK: - RouterExtendedProtocol
    func route(in view: BaseView, replace: Bool, animated: Bool) {
        if replace {
            view.replace(with: module, animated: animated)
        } else {
            view.open(module: module)
        }
    }
}
