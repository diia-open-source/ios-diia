import Foundation
import DiiaCommonTypes
import DiiaDocumentsCommonTypes

// MARK: - DocumentsResponse
public struct DocumentsResponse: Codable {
    public let driverLicense: DSFullDocumentModel?

    let documentsTypeOrder: [String]?

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let driverLicenseFailable = try container.decodeIfPresent(FailableDecodable<DSFullDocumentModel>.self, forKey: .driverLicense)
        driverLicense = driverLicenseFailable?.value

        documentsTypeOrder = try container.decodeIfPresent([String].self, forKey: .documentsTypeOrder)
    }
}
