import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaAuthorization
       
final class ProlongStartModule: BaseModule {
    private let view: ProlongStartViewController
    private let presenter: ProlongStartPresenter
    
    init(completionHandler: @escaping Callback) {
        view = ProlongStartViewController.storyboardInstantiate()
        view.modalPresentationStyle = .fullScreen
        presenter = ProlongStartPresenter(view: view, apiClient: AuthorizationApiClient.create(), completionHandler: completionHandler)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
