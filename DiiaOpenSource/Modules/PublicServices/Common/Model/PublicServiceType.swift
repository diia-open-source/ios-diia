import Foundation
import DiiaCommonTypes

enum PublicServiceType: String, Codable, EnumDecodable, CaseIterable {
    static let defaultValue: PublicServiceType = .unknown
    
    case unknown
    case criminalRecordCertificate
    
    var endpoint: String {
        switch self {
        case .criminalRecordCertificate:
            return "criminal-cert"
        default:
            return self.rawValue
        }
    }
}
