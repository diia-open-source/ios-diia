import Foundation
import DiiaNetwork

enum DocumentReorderingAPI: CommonService {
    case sendDocumentsOrder(order: [DocType])
    case sendStackOrder(order: [String], type: DocType)

    var method: HTTPMethod {
        return .post
    }

    var path: String {
        switch self {
        case .sendDocumentsOrder:
            return "v2/user/settings/documents/order"
        case .sendStackOrder(_, let type):
            return "v2/user/settings/documents/\(type.rawValue)/order"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .sendDocumentsOrder(let order):
            let dict = [
                "documentsOrder": order.enumerated().map({ (index, element) in
                    return ["documentType": element.rawValue, "order": index+1] as [String: Any]
                })
            ]
            return dict
        case .sendStackOrder(let order, _):
            return [
                "documentsOrder": order.enumerated().map({ (index, element) in
                    return ["docNumber": element, "order": index+1] as [String: Any]
                })
            ]
        }
    }
    
    var analyticsName: String {
        switch self {
        case .sendDocumentsOrder:
            return NetworkActionKey.sendDocumentsOrder.rawValue
        case .sendStackOrder:
            return NetworkActionKey.sendStackOrder.rawValue
        }
    }
}
