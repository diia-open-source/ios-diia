
import UIKit
import DiiaMVPModule

final class FeedNewsModule: BaseModule {
    private let view: FeedNewsViewController
    private let presenter: FeedNewsPresenter
    
    init() {
        view = FeedNewsViewController()
        presenter = FeedNewsPresenter(view: view)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
