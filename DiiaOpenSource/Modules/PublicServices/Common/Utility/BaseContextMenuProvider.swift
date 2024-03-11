import Foundation
import DiiaMVPModule
import DiiaUIComponents
import DiiaCommonTypes

struct BaseContextMenuProvider: ContextMenuProviderProtocol {
    // MARK: - Properties
    private var items: [ContextMenuItem]
    private let publicService: PublicServiceType?
    var title: String?
    
    // MARK: - Public Methods
    init(publicService: PublicServiceType? = nil,
         title: String? = nil,
         items: [ContextMenuItem] = []) {
        self.items = items
        self.title = title
        self.publicService = publicService
    }

    func hasContextMenu() -> Bool {
        return items.count > 0
    }
    
    func openContextMenu(in view: BaseView) {
        let actions = prepareActions(in: view)
        if actions.count < 1 { return }
        let module = ActionSheetModule(actions: actions)
        view.showChild(module: module)
    }
    
    mutating func setContextMenu(items: [ContextMenuItem]?) {
        self.items = items ?? []
    }
    
    mutating func setTitle(title: String?) {
        self.title = title
    }
    
    // MARK: - Private Methods
    private func prepareActions(in view: BaseView) -> [[Action]] {
        var actions: [[Action]] = []
            
        items.forEach {
            if let action = prepareAction(for: $0, in: view) {
                actions.append(action)
            }
        }
        
        return actions
    }

    private func prepareAction(for item: ContextMenuItem, in view: BaseView) -> [Action]? {
        switch item.type {
        case .supportServiceScreen:
            return [
                Action(title: item.name, iconName: nil, callback: { [weak view] in
                    let module = HorizontalActionSheetModule(title: R.Strings.menu_support.localized(),
                                                             actions: CommunicationHelper.getCommunicationsActions())
                    view?.showChild(module: module)
                })
            ]
        default:
            return nil
        }
    }
    
}
