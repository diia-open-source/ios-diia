import Foundation
import DiiaNetwork

enum SharingDocsAPI: CommonService {
    case shareDriverLicense(documentId: String, localization: String?)
    case shareDocument(docType: String, documentId: String, localization: String?)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .shareDriverLicense(let documentId, _):
            return "v1/documents/driver-license/\(documentId)/share"
        case .shareDocument(let docType, let documentId, _):
            return "v2/documents/\(docType)/\(documentId)/share"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .shareDocument(_, _, let localization),
                .shareDriverLicense(_, let localization):
            if let localization = localization {
                return ["localization": localization]
            }
            return nil
        }
    }
    
    var analyticsName: String {
        return "analyticsName"
    }
}
