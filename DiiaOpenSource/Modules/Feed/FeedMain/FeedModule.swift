
import UIKit
import DiiaMVPModule

final class FeedModule: BaseModule {
    private let view: FeedViewController
    private let presenter: FeedPresenter
    
    init() {
        view = FeedViewController()
        presenter = FeedPresenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
