
import DiiaCommonTypes
import DiiaUIComponents

protocol ContextMenuConfigurable {
    var view: ConstructorScreenViewProtocol { get set }
}

extension ContextMenuConfigurable {
    func updateContextMenu(model: DSConstructorModel, in contextMenuProvider: inout ContextMenuProviderProtocol) {
        guard let navPanel = model.navigationPanelMlc else { return }
        
        contextMenuProvider.setTitle(title: navPanel.label)
        contextMenuProvider.setContextMenu(items: navPanel.ellipseMenu)
        view.setHeader(headerContext: contextMenuProvider)
    }
}
