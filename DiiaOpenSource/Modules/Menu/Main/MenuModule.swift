import UIKit
import DiiaMVPModule
       
final class MenuModule: BaseModule {
    private let view: MenuViewController
    private let presenter: MenuPresenter
    
    init() {
        view = MenuViewController.storyboardInstantiate()
        presenter = MenuPresenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
