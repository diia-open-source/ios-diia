import UIKit
import DiiaMVPModule
       
final class MainTabBarModule: BaseModule {
    private let view: MainTabBarViewController
    private let presenter: MainTabBarPresenter
    
    init() {
        view = MainTabBarViewController.storyboardInstantiate()
        presenter = MainTabBarPresenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
