import Foundation
import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes

class DocumentReorderingAPIClient: ApiClient<DocumentReorderingAPI> {
    func sendDocumentsOrder(order: [DocType]) -> Signal<SuccessResponse, NetworkError> {
        return request(.sendDocumentsOrder(order: order))
    }
    
    func sendOrder(order: [String], for documentType: DocType) -> Signal<SuccessResponse, NetworkError> {
        return request(.sendStackOrder(order: order, type: documentType))
    }
}
