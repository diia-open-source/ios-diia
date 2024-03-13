import UIKit
import DiiaMVPModule
import DiiaCommonTypes

protocol SplashScreenAction: BasePresenter {
	func didFinishAnimations()
}

final class SplashScreenPresenter: SplashScreenAction {
    
    private let onFinish: Callback
    
    init(onFinish: @escaping Callback) {
        self.onFinish = onFinish
    }
    
    func didFinishAnimations() {
        onFinish()
    }
}
