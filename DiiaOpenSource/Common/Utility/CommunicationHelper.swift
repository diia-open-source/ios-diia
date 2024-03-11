import UIKit
import DiiaCommonTypes
import DiiaUIComponents

class CommunicationHelper {
    
    static let telegramBotName = "Diia_help_bot?start=X3VybD0lMkZsaW5rJmQ9MQ=="
    static let facebookSupportUrl = "https://m.me/105597857511240?ref=X3VybD0lMkZsaW5rJmQ9MQ=="
    static let viberBotName = "diia_help_bot&context=X3VybD0lMkZsaW5rJmQ9MQ=="

    static func getCommunicationsActions() -> [Action] {
        return [
            Action(title: Constants.Messengers.telegram, iconName: R.image.telegram.name, callback: {
                if CommunicationHelper.telegram(botName: CommunicationHelper.telegramBotName) == false {
                    showMessengerNotInstalledAlert(Constants.Messengers.telegram)
                }
            }),
            Action(title: Constants.Messengers.facebook, iconName: R.image.facebookMessenger.name, callback: {
                if CommunicationHelper.url(urlString: CommunicationHelper.facebookSupportUrl, linkType: .facebook) == false {
                    showMessengerNotInstalledAlert(Constants.Messengers.facebook)
                }
            }),
            Action(title: Constants.Messengers.viber, iconName: R.image.viber.name, callback: {
                if CommunicationHelper.viber(chatURI: CommunicationHelper.viberBotName) == false {
                    showMessengerNotInstalledAlert(Constants.Messengers.viber)
                }
            })
        ]
    }
    
    private static func showMessengerNotInstalledAlert(_ messenger: String) {
        guard let topController = UIApplication.shared.windows.first?.visibleViewController else { return }
        
        let alert = UIAlertController(title: R.Strings.communication_bot_not_available.localized(),
                                      message: R.Strings.communication_messenger_not_installed.formattedLocalized(arguments: messenger),
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.Strings.general_problem_ok.localized(), style: .default)
        alert.addAction(okAction)
        
        topController.present(alert, animated: true)
    }
    
    @discardableResult
    static func tryURL(urls: [String]) -> Bool {
        let application = UIApplication.shared
        for strUrl in urls {
            if let url = URL(string: strUrl), application.canOpenURL(url) {
                application.open(url)
                return true
            }
        }
        return false
    }
    
    @discardableResult
    static func url(urlString: String?, linkType: LinkType? = nil) -> Bool {
        if let urlString = urlString, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            let link = linkType ?? LinkType(url: urlString)
            askApprove(link: link) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            return true
        }
        
        return false
    }
    
    @discardableResult
    static func telegram(botName: String) -> Bool {
        return url(urlString: "tg://resolve?domain=\(botName)", linkType: .telegram)
    }
    
    @discardableResult
    static func viber(chatURI: String) -> Bool {
        return url(urlString: "viber://pa?chatURI=\(chatURI)", linkType: .viber)
    }
    
    // MARK: - Helping Methods
    private static func askApprove(link: LinkType, onApprove: @escaping Callback) {
        var linksApproved: [LinkType: Bool] = StoreHelper.instance.getValue(forKey: .didUserApproveLinks) ?? [:]
        if linksApproved[link] == true {
            onApprove()
            return
        }
        
        guard let topController = UIApplication.shared.windows.first?.visibleViewController else { return }
        
        let title: String
        switch link {
        case .browser:
            title = R.Strings.communication_wants_open.formattedLocalized(arguments: link.rawValue)
        default:
            title = R.Strings.communication_wants_open_named.formattedLocalized(arguments: link.rawValue)
        }
        
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: R.Strings.communication_open_cancel.localized(), style: .default)
        let okAction = UIAlertAction(title: R.Strings.communication_open_accept.localized(), style: .default) { (_) in
            linksApproved[link] = true
            StoreHelper.instance.save(linksApproved, type: [LinkType: Bool].self, forKey: .didUserApproveLinks)
            onApprove()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        alert.preferredAction = okAction
        
        topController.present(alert, animated: true)
    }
}

// MARK: - Constants
extension CommunicationHelper {
    private enum Constants {
        enum Messengers {
            static let telegram = "Telegram"
            static let viber = "Viber"
            static let facebook = "Facebook Messenger"
        }
    }
    enum LinkType: String, Codable {
        case telegram = "Telegram"
        case viber = "Viber"
        case facebook = "Facebook Messenger"
        case browser = "Веб-браузер"
        
        init(url: String) {
            switch url {
            case let str where str.starts(with: "tg:"):
                self = .telegram
            case let str where str.starts(with: "viber:"):
                self = .viber
            case let str where str.starts(with: "fb:"):
                self = .facebook
            default:
                self = .browser
            }
        }
    }
}

struct URLOpenerImpl: URLOpenerProtocol {
     func url(urlString: String?, linkType: String?) -> Bool {
         CommunicationHelper.url(urlString: urlString, linkType: CommunicationHelper.LinkType(url: linkType ?? ""))
     }
    
     func tryURL(urls: [String]) -> Bool {
         CommunicationHelper.tryURL(urls: urls)
     }
 }
