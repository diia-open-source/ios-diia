import UIKit
import DiiaMVPModule
import DiiaAuthorization
       
final class StartAuthorizationModule: BaseModule {
    private let view: StartAuthorizationViewController
    private let presenter: StartAuthorizationPresenter
    
    init() {
        view = StartAuthorizationViewController.storyboardInstantiate()
        presenter = StartAuthorizationPresenter(view: view, authApiClient: AuthorizationApiClient.create())
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
