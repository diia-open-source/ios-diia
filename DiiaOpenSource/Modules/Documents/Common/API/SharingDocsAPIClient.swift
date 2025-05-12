import ReactiveKit
import DiiaDocumentsCommonTypes
import DiiaNetwork

class SharingDocsAPIClient: ApiClient<SharingDocsAPI>, SharingDocsApiClientProtocol {
    
    // MARK: - Share
    func shareDriverLicense(documentId: String, localization: String?) -> Signal<ShareLinkModel, NetworkError> {
        return request(.shareDriverLicense(documentId: documentId, localization: localization))
    }
    
    func shareDocument(docType: String, documentId: String, localization: String?) -> Signal<ShareVerificationCodesModel, NetworkError> {
        return request(.shareDocument(docType: docType, documentId: documentId, localization: localization))
    }
}
