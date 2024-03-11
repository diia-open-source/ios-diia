import UIKit
import DiiaMVPModule
       
final class SettingsModule: BaseModule {
    private let view: SettingsViewController
    private let presenter: SettingsPresenter
    
    init() {
        view = SettingsViewController.storyboardInstantiate()
        presenter = SettingsPresenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
