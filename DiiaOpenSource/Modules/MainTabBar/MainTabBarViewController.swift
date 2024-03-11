import UIKit
import Lottie
import DiiaMVPModule
import DiiaUIComponents

protocol MainEmbeddable: UIViewController {
    func onSameSelected()
    func processAction(action: String)
}

protocol MainTabRoutingProtocol: UIViewController {
    func processAction(action: MainTabAction)
}

protocol MainTabBarView: BaseView {
    func updateView()
    func setupCurrentController(_ viewController: UIViewController)
    func setupSelectedItem(index: Int)
    func updateTopColor(tabColor: TabBarColor)
    func configureTopView(isHidden: Bool, topButtonIcon: String?)
    func updateBottomColor(tabColor: TabBarColor)
    func onSameSelected()
    func processChildAction(action: String)
    func setBackground(background: TabBarBackground)
}

enum TabBarColor {
    case fixed(colorHex: String)
    case adaptive
}

enum TabBarBackground {
    case image(image: UIImage?)
    case animation(name: String)
    case clear
}

final class MainTabBarViewController: UIViewController, Storyboarded {

    // MARK: - Outlets
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var backgroundImageView: UIImageView!
    @IBOutlet weak private var backgroundAnimationView: LottieAnimationView!
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var topView: UIView!
    @IBOutlet weak private var logoContainer: UIView!
    @IBOutlet weak private var bottomView: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var qrScannerButton: UIButton!

    @IBOutlet weak private var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var logoLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var logoBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var presenter: MainTabBarAction!
    private var bottomColorObservation: NSKeyValueObservation?
    private var topColorObservation: NSKeyValueObservation?

    private var currentChild: UIViewController?
    private var currentIndex: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoHeightConstraint.constant = Constants.logoHeight
        logoLeadingConstraint.constant = Constants.logoLeading
        logoTopConstraint.constant = Constants.logoTop
        logoBottomConstraint.constant = Constants.logoBottom
        titleLabel.font = FontBook.smallHeadingFont
        presenter.configureView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.updateSelectionIfNeed(for: currentIndex)
    }
    
    // MARK: - Overriding
    override func canGoBack() -> Bool {
        return false
    }
    
    // MARK: - Actions
    @IBAction func qrScannerBtnPressed(_ sender: Any) {
        presenter.topButtonClicked()
    }
}

// MARK: - View logic
extension MainTabBarViewController: MainTabBarView {
    func setupCurrentController(_ viewController: UIViewController) {
        if currentChild == viewController { return }
        if let oldVC = currentChild {
            VCChildComposer.removeChild(oldVC, from: self, animationType: .none)
        }
        
        VCChildComposer.addChild(viewController, to: self, in: containerView, animationType: .none)
        
        titleLabel.setTextWithCurrentAttributes(text: viewController.title ?? "")
        currentChild = viewController
    }
    
    func setupSelectedItem(index: Int) {
        currentIndex = index
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let cell = collectionView.cellForItem(at: indexPath) as? MainTabCollectionCell {
                configureCell(cell,
                              cellForItemAt: indexPath,
                              selectedIndex: index)
            }
        }
    }
    
    func updateView() {
        collectionView.reloadData()
    }
    
    func updateTopColor(tabColor: TabBarColor) {
        switch tabColor {
        case .fixed(let color):
            topColorObservation = nil
            topView.backgroundColor = UIColor(color)
        case .adaptive:
            topColorObservation = currentChild?.view.observe(\.backgroundColor, onChange: { [weak self] (color) in
                self?.topView.backgroundColor = color
            })
        }
    }
    
    func configureTopView(isHidden: Bool, topButtonIcon: String?) {
        topView.isHidden = isHidden
        logoBottomConstraint.constant = isHidden ? Constants.logoBottomInMenu : Constants.logoBottom
        logoContainer.isHidden = isHidden
        view.layoutIfNeeded()
        if let icon = topButtonIcon, let image = UIImage(named: icon) {
            qrScannerButton.isHidden = false
            qrScannerButton.setImage(image, for: .normal)
            qrScannerButton.accessibilityLabel = R.Strings.main_screen_accessibility_top_qr_scanner_button.localized()
        } else {
            qrScannerButton.isHidden = true
        }
    }
    
    func updateBottomColor(tabColor: TabBarColor) {
        switch tabColor {
        case .fixed(let color):
            bottomColorObservation = nil
            bottomView.backgroundColor = UIColor(color)
        case .adaptive:
            bottomColorObservation = currentChild?.view.observe(\.backgroundColor, onChange: { [weak self] (color) in
                self?.bottomView.backgroundColor = color
            })
        }
    }
    
    func onSameSelected() {
        guard let currentController = currentChild as? MainEmbeddable else { return }
        
        currentController.onSameSelected()
    }
    
    func processChildAction(action: String) {
        guard let currentController = currentChild as? MainEmbeddable else { return }
        
        currentController.processAction(action: action)
    }
    
    func setBackground(background: TabBarBackground) {
        switch background {
        case .image(let image):
            guard let image = image else { return }
            backgroundImageView.isHidden = false
            backgroundImageView.image = image
            backgroundAnimationView.isHidden = true
        case .animation(let name):
            backgroundImageView.isHidden = true
            backgroundAnimationView.isHidden = false
            backgroundAnimationView.animation = .named(name)
            backgroundAnimationView.loopMode = .loop
            backgroundAnimationView.backgroundBehavior = .pauseAndRestore
            backgroundAnimationView.contentMode = .scaleAspectFill
            backgroundAnimationView.play()
        case .clear:
            backgroundImageView.isHidden = true
            backgroundAnimationView.isHidden = true
        }
    }
}

extension MainTabBarViewController: MainTabRoutingProtocol {
    func processAction(action: MainTabAction) {
        presenter.processAction(action: action)
    }
}

// MARK: - Collection View Methods
extension MainTabBarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm = presenter.itemAt(with: indexPath.item) else { return UICollectionViewCell() }

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainTabCollectionCell.reuseID, for: indexPath) as? MainTabCollectionCell {
            cell.configure(with: vm)
            configureCell(cell,
                          cellForItemAt: indexPath,
                          selectedIndex: currentIndex)

            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension MainTabBarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectItem(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MainTabBarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(presenter.numberOfItems()), height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - Private methods
private extension MainTabBarViewController {
    func configureCell(_ cell: MainTabCollectionCell,
                       cellForItemAt indexPath: IndexPath,
                       selectedIndex: Int) {
        cell.setSelected(isSelected: indexPath.item == selectedIndex)
        cell.configureAccessibility(isSelected: indexPath.item == selectedIndex,
                                    currentValue: indexPath.item + 1,
                                    totalValue: presenter.numberOfItems())
    }
}

// MARK: - Constants
private extension MainTabBarViewController {
    enum Constants {
        static var logoHeight: CGFloat {
            switch UIDevice.size() {
            case .screen4Inch:
                return 40
            case .screen5_5Inch, .screen6_1Inch, .screen6_5Inch:
                return 53
            default:
                return 48
            }
        }
        
        static var logoLeading: CGFloat {
            switch UIDevice.size() {
            case .screen4Inch, .screen_zoomed:
                return 20
            case .screen5_5Inch, .screen6_1Inch, .screen6_5Inch:
                return 26
            default:
                return 24
            }
        }
        
        static var logoTop: CGFloat {
            switch UIDevice.size() {
            case .screen4Inch, .screen_zoomed:
                return 17
            case .screen5_5Inch, .screen6_1Inch, .screen6_5Inch:
                return 22
            default:
                return 20
            }
        }
        
        static var logoBottom: CGFloat {
            switch UIDevice.size() {
            case .screen4Inch, .screen_zoomed:
                return 13
            case .screen5_5Inch, .screen6_1Inch, .screen6_5Inch:
                return 18
            default:
                return 16
            }
        }
        
        static var logoBottomInMenu: CGFloat {
            switch UIDevice.size() {
            case .screen4Inch, .screen_zoomed:
                return 26
            case .screen5_5Inch, .screen6_1Inch, .screen6_5Inch:
                return 36
            default:
                return 32
            }
        }
    }
}
