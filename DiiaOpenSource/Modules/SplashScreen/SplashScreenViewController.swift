import UIKit
import Lottie
import DiiaMVPModule
import DiiaUIComponents

protocol SplashScreenView: BaseView {}

final class SplashScreenViewController: UIViewController, Storyboarded {

	// MARK: - Properties
	var presenter: SplashScreenAction!

    // MARK: - Outlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var animationView: LottieAnimationView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
        presenter.configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView.play()
        onMainQueueAfter(time: LocalConstants.animationDuration) { [weak self] in
            self?.presenter.didFinishAnimations()
        }
    }
    
    // MARK: - Private Methods
    private func initialSetup() {
        titleLabel.font = FontBook.grandTextFont
        titleLabel.text = R.Strings.authorization_welcome.localized()
        animationView.loopMode = .playOnce
        animationView.backgroundBehavior = .pauseAndRestore
    }
}

// MARK: - View logic
extension SplashScreenViewController: SplashScreenView {}

extension SplashScreenViewController {
    private enum LocalConstants {
        static let animationDuration: Double = 3
    }
}
