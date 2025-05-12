
import UIKit
import DiiaMVPModule
import DiiaCommonTypes

final class FeedNewsDetailsModule: BaseModule {
    private let view: FeedNewsDetailsViewController
    private let presenter: FeedNewsDetailsPresenter
    
    init(newsId: String, errorCallback: Callback? = nil) {
        view = FeedNewsDetailsViewController()
        presenter = FeedNewsDetailsPresenter(
            view: view,
            newsId: newsId,
            errorCallback: errorCallback)
        view.presenter = presenter
    }

    func viewController() -> UIViewController {
        return view
    }
}
