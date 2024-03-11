import Foundation
import DiiaNetwork

enum SharingDocsAPI: CommonService {
    case shareDriverLicense(documentId: String, localization: String?)
    
    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .shareDriverLicense(let documentId, _):
            return "v1/documents/driver-license/\(documentId)/share"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .shareDriverLicense(_, let localization):
            if let localization = localization {
                return ["localization": localization]
            }
            return nil
        }
    }
    
    var analyticsName: String {
        switch self {
        case .shareDriverLicense:
            return NetworkActionKey.shareDriverLicense.rawValue
        }
    }
}
