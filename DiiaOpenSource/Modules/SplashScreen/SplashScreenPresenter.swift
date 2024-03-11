import UIKit
import DiiaMVPModule
import DiiaCommonTypes

protocol SplashScreenAction: BasePresenter {
	func didFinishAnimations()
}

final class SplashScreenPresenter: SplashScreenAction {
    unowned var view: SplashScreenView
    
    private let onFinish: Callback
    
    init(view: SplashScreenView, onFinish: @escaping Callback) {
        self.onFinish = onFinish
        self.view = view
    }
    
    func didFinishAnimations() {
        onFinish()
    }
}
