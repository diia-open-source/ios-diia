import UIKit
import DiiaMVPModule
import DiiaUIComponents
import DiiaAuthorization

protocol MenuAction: BasePresenter {
    func logout()
    func showPersonalDataMessage()
}

final class MenuPresenter: MenuAction {
    private unowned var view: MenuView
    
    init(view: MenuView) {
        self.view = view
    }
    
    func configureView() {
        view.setTitle(title: R.Strings.main_screen_menu.localized())
        setupSettings()
    }
    
    func logout() {
        ServicesProvider.shared.authService.logout()
    }
    
    func showPersonalDataMessage() {
        CommunicationHelper.url(urlString: Constants.policyUrlString)
    }
    
    // MARK: - Configuration
    private func setupSettings() {
        view.clearStack()
        view.addList(list: .init(items: messagesSection()))
        view.addList(list: .init(items: diiaIDSections()))
        view.addList(list: .init(items: generalSections()))
        view.addList(list: .init(items: communicationSections()))
        if EnvironmentVars.isInDebug {
            view.addList(list: .init(componentId: nil, title: "Режим розробника", items: devTools()))
        }
    }
}

private extension MenuPresenter {
    func messagesSection() -> [DSListItemViewModel] {
        return [
            DSListItemViewModel(
                leftSmallIcon: R.image.menuNotifications.image,
                title: R.Strings.menu_notifications.localized(),
                onClick: { })
        ]
    }
    
    func diiaIDSections() -> [DSListItemViewModel] {
        return [
            DSListItemViewModel(
                leftSmallIcon: R.image.menuDiiaID.image,
                title: R.Strings.menu_diia_id.localized(),
                onClick: { }),
            DSListItemViewModel(
                leftSmallIcon: R.image.menuDiiaIDHistory.image,
                title: R.Strings.menu_diia_id_history.localized(),
                onClick: { })
        ]
    }
    
    func generalSections() -> [DSListItemViewModel] {
        return [
            DSListItemViewModel(
                leftSmallIcon: R.image.settings.image,
                title: R.Strings.menu_title_settings.localized(),
                onClick: { [weak self] in
                    self?.view.open(module: SettingsModule())
                }),
            DSListItemViewModel(
                leftSmallIcon: R.image.menuUpdate.image,
                title: R.Strings.menu_update.localized(),
                onClick: { }),
            DSListItemViewModel(
                leftSmallIcon: R.image.menuActiveSessions.image,
                title: R.Strings.menu_active_sessions.localized(),
                onClick: { })
        ]
    }
    
    func communicationSections() -> [DSListItemViewModel] {
        return [
            DSListItemViewModel(
                leftSmallIcon: R.image.menuSupport.image,
                title: R.Strings.menu_support.localized(),
                onClick: { [weak self] in
                    let module = ActionSheetV2Module(actions: CommunicationHelper.getCommunicationsActions())
                    self?.view.showChild(module: module)
                }),
            DSListItemViewModel(
                leftSmallIcon: R.image.menuCopyUID.image,
                title: R.Strings.menu_copy_uid.localized(),
                onClick: { [weak self] in
                    UIPasteboard.general.string = AppConstants.App.mobileUID
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    let msg = R.Strings.general_template_text_copied.formattedLocalized(arguments: R.Strings.general_phone_uuid.localized())
                    self?.view.showSuccessMessage(message: msg)
                }),
            DSListItemViewModel(
                leftSmallIcon: R.image.menuFaq.image,
                title: R.Strings.menu_faq.localized(),
                onClick: { })
        ]
    }
    
    func devTools() -> [DSListItemViewModel] {
        return [
            DSListItemViewModel(
                id: "",
                title: "Тест конструктора дизайн системи",
                onClick: { [weak self] in
                    self?.view.open(module: ConstructorMockV2Module(contextMenuProvider: BaseContextMenuProvider()))
                })
        ]
    }
}

// MARK: - Constants
extension MenuPresenter {
    private enum Constants {
        static let policyUrlString = "https://diia.gov.ua/app_policy"
    }
}
