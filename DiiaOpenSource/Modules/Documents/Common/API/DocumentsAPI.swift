import Foundation
import DiiaNetwork

enum DocumentsAPI: CommonService {

    case getDocuments(filter: [String])

    var timeoutInterval: TimeInterval {
        return 30
    }

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .getDocuments:
            return "v6/documents"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .getDocuments(let filter):
            return ["filter": filter]
        }
    }
    
    var analyticsName: String {
        switch self {
        case .getDocuments:
            return NetworkActionKey.getDocs.rawValue
        }
    }
}
