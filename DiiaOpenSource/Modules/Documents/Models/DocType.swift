import UIKit
import DiiaDocumentsCommonTypes

enum DocType: String, Codable, CaseIterable {
    case driverLicense = "driver-license"
    case taxpayerСard = "taxpayer-card"

    init?(rawValue: String) {
        switch rawValue {
        case "driver-license", "driverLicense":
            self = .driverLicense
        case "taxpayer-card", "taxpayerСard":
            self = .taxpayerСard
        default:
            return nil
        }
    }
    
    var name: String {
        switch self {
        case .driverLicense:
            return R.Strings.driver_document_name.localized()
        case .taxpayerСard:
            return ""
        }
    }

    var stackName: String {
        return name
    }

    static var allCardTypes: [DocType] {
        return DocType.allCases
    }

    var faqCategoryId: String {
        switch self {
        case .driverLicense: return "driverLicense"
        case .taxpayerСard: return ""
        }
    }

    func storingKey() -> StoringKey? {
        switch self {
        case .driverLicense:
            return .driverLicense
        case .taxpayerСard:
            return nil
        }
    }
}

extension DocType: DocumentAttributesProtocol {
    var docCode: DocTypeCode { return self.rawValue }

    func warningModel() -> WarningModel? {
        return nil
    }

    var stackIconAppearance: DocumentStackIconAppearance {
        return .black
    }

    var isStaticDoc: Bool {
        return false
    }

    func isDocCodeSameAs(otherDocCode: DocTypeCode) -> Bool {
        DocType(rawValue: docCode) == DocType(rawValue: otherDocCode)
    }
}
