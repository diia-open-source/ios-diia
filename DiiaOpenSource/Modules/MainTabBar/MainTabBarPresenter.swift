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
                iconName: R.image.menuFeedInactive.name,
                title: R.Strings.main_screen_feed.localized(),
                selectedIconName: R.image.menuFeedActive.name
            )
        case .services:
            return SelectableIconTitleViewModel(
                iconName: R.image.menuServicesInactive.name,
                title: R.Strings.main_screen_services.localized(),
                selectedIconName: R.image.menuServicesActive.name
            )
        case .documents:
            return SelectableIconTitleViewModel(
                iconName: R.image.menuDocumentsInactive.name,
                title: R.Strings.main_screen_documents.localized(),
                selectedIconName: R.image.menuDocumentsActive.name
            )
        case .menu:
            return SelectableIconTitleViewModel(
                iconName: R.image.menuSettingsInactive.name,
                title: R.Strings.main_screen_menu.localized(),
                selectedIconName: R.image.menuSettingsActive.name
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
            view.setBackground(background: .image(image: R.image.light_background.image))
        case .services(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .image(image: R.image.light_background.image))
        case .documents(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .animation(name: "background_gradient"))
        case .menu(let viewController):
            view.setupCurrentController(viewController)
            view.setBackground(background: .image(image: R.image.light_background.image))
        }
        view.setupSelectedItem(index: index)
    }
    
    func processAction(action: MainTabAction) {
        switch action {
        case .documents(let type):
            if currentIndex != 0 {
                selectItem(at: 0)
            }
            if let docType = type?.rawValue {
                view.processChildAction(action: docType)
            }
        default:
            break
        }
    }
}

extension MainTabBarPresenter: DocumentCollectionHolderProtocol {
    func updateBackgroundImage(image: UIImage?) {
        guard let image = image else { return }
        view.setBackground(background: .image(image: image))
    }
}
