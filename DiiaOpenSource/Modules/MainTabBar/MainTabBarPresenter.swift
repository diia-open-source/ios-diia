import UIKit
import DiiaMVPModule
import DiiaDocumentsCommonTypes

protocol MainTabBarAction: BasePresenter {
    func numberOfItems() -> Int
    func itemAt(with index: Int) -> SelectableIconTitleViewModel?
    func selectItem(at index: Int)
    func updateSelectionIfNeed(for currentIndex: Int)
    func topButtonClicked()
    func processAction(action: MainTabAction)
}

private enum TabType {
    case services(view: UIViewController)
    case documents(view: UIViewController)
    case menu(view: UIViewController)
    case feed(view: UIViewController)
    
    func isSameForAction(_ action: MainTabAction) -> Bool {
        switch self {
        case .services:
            return action == .publicService
        case .documents:
            switch action {
            case .documents:
                return true
            default:
                return false
            }
        case .menu:
            return action == .settings
        case .feed:
            return action == .feed
        }
    }
}

final class MainTabBarPresenter: NSObject, MainTabBarAction {
    unowned var view: MainTabBarView
    private var currentIndex: Int?

    private var tabs: [TabType] = []
    private let qrHelper: DiiaQRScannerHelper

    // MARK: - Init
    init(view: MainTabBarView) {
        self.view = view
        qrHelper = DiiaQRScannerHelper(presentingView: view)
    }
    
    func configureView() {
        tabs = [
            .feed(view: FeedModule().viewController()),
            .documents(view: DocumentsCollectionModuleFactory.create(holder: self).viewController()),
            .services(view: PublicServiceCategoriesListModuleFactory.create().viewController()),
            .menu(view: MenuModule().viewController())
        ]
        
        view.updateTopColor(tabColor: .fixed(colorHex: AppConstants.Colors.clear))
        view.configureTopView(isHidden: true, topButtonIcon: nil)
        view.updateBottomColor(tabColor: .fixed(colorHex: AppConstants.Colors.black))
    }
    
    func topButtonClicked() {
        CameraAccessChecker.askCameraAccess {[weak self] (granted) in
            if granted, let delegate = self?.qrHelper {
                self?.view.open(module: QRCodeScannerModule(delegate: delegate))
            }
        }
    }
    
    func updateSelectionIfNeed(for currentIndex: Int) {
        if currentIndex == self.currentIndex {
            return
        }
        selectItem(at: currentIndex)
    }
    
    func numberOfItems() -> Int {
        return tabs.count
    }
    
    func itemAt(with index: Int) -> SelectableIconTitleViewModel? {
        guard tabs.indices.contains(index) else { return nil }
        
        switch tabs[index] {
        case .feed:
            return SelectableIconTitleViewModel(
                icon: UIImage.menuFeedInactive,
                title: R.Strings.main_screen_feed.localized(),
                selectedIcon: UIImage.menuFeedActive
            )
        case .services:
            return SelectableIconTitleViewModel(
                icon: UIImage.menuServicesInactive,
                title: R.Strings.main_screen_services.localized(),
                selectedIcon: UIImage.menuServicesActive
            )
        case .documents:
            return SelectableIconTitleViewModel(
                icon: UIImage.menuDocumentsInactive,
                title: R.Strings.main_screen_documents.localized(),
                selectedIcon: UIImage.menuDocumentsActive
            )
        case .menu:
            return SelectableIconTitleViewModel(
                icon: UIImage.menuSettingsInactive,
                title: R.Strings.main_screen_menu.localized(),
                selectedIcon: UIImage.menuSettingsActive
            )
        }
    }
    
    func selectItem(at index: Int) {
        guard tabs.indices.contains(index) else { return }
        if currentIndex == index {
            view.onSameSelected()
            return
        }
        currentIndex = index
        
        switch tabs[index] {
        case .feed(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .image(image: UIImage.lightBackground))
        case .services(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .image(image: UIImage.lightBackground))
        case .documents(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .animation(name: "background_gradient"))
        case .menu(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .image(image: UIImage.lightBackground))
        }
        view.setupSelectedItem(index: index)
    }
    
    func processAction(action: MainTabAction) {
        if let newIndex = tabs.firstIndex(where: { $0.isSameForAction(action) }),
           currentIndex != newIndex {
            selectItem(at: newIndex)
        }
        switch action {
        case .documents(let type):
            if let docType = type?.rawValue {
                view.processChildAction(action: docType)
            }
        default: break
        }
    }
}

extension MainTabBarPresenter: DocumentCollectionHolderProtocol {
    func updateBackgroundImage(image: UIImage?) {
        guard let image = image else { return }
        view.setBackground(background: .image(image: image))
    }
}
