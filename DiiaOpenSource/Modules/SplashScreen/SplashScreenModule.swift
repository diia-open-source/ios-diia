import UIKit
import DiiaMVPModule
import DiiaCommonTypes

final class SplashScreenModule: BaseModule {
    private let view: SplashScreenViewController
    private let presenter: SplashScreenPresenter
    
    init(onFinish: @escaping Callback) {
        view = SplashScreenViewController.storyboardInstantiate()
        presenter = SplashScreenPresenter(view: view, onFinish: onFinish)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
