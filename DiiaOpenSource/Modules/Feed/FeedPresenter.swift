import UIKit
import DiiaMVPModule

protocol FeedAction: BasePresenter {

}

final class FeedPresenter: FeedAction {
    
    // MARK: - Properties
    unowned var view: FeedView
    
    // MARK: - Init
    init(view: FeedView) {
        self.view = view
    }
    
}
