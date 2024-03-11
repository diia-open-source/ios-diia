import Foundation
import ReactiveKit
import DiiaNetwork
import DiiaDocumentsCommonTypes

public protocol DocumentsAPIClientProtocol {
    func getDocuments(_ types: [DocTypeCode]) -> Signal<DocumentsResponse, NetworkError>
}

class DocumentsAPIClient: ApiClient<DocumentsAPI>, DocumentsAPIClientProtocol {
    func getDocuments(_ types: [DocTypeCode] = []) -> Signal<DocumentsResponse, NetworkError> {
        return request(.getDocuments(filter: types))
    }
}
