import UIKit
import DiiaMVPModule
import DiiaCommonTypes
import DiiaDocumentsCommonTypes
import DiiaDocumentsCore

class DocumentsProcessor {
    private let storeHelper: StoreHelperProtocol
    
    init(storeHelper: StoreHelperProtocol = StoreHelper.instance) {
        self.storeHelper = storeHelper
    }
    
    func documents(with order: [DocTypeCode], actionView: BaseView?) -> [MultiDataType<DocumentModel>] {
        
        let docTypesOrder: [DocType] = order.compactMap({ DocType(rawValue: $0)})
        
        let documents = docTypesOrder.compactMap { docType -> MultiDataType<DocumentModel>? in
            switch docType {
            case .driverLicense:
                let driverLicense: DSFullDocumentModel? = storeHelper.getValue(forKey: .driverLicense)
                return makeMultiple(cards: processDriverLicenses(licenses: driverLicense))
            case .taxpayerСard:
                return nil
            }
        }
        
        return documents
    }
    
    private func makeMultiple(cards: [DocumentModel]) -> MultiDataType<DocumentModel>? {
        if cards.isEmpty {
            return nil
        } else if cards.count == 1 {
            return .single(cards[0])
        } else {
            return .multiple(cards)
        }
    }
    
    private func reorderIfNeeded(documents: [DocumentModel], orderIds: [String]) -> [DocumentModel] {
        if !orderIds.isEmpty {
            var newDocs = documents
            for id in orderIds.reversed() {
                if let index = newDocs.firstIndex(where: { $0.orderIdentifier == id }) {
                    let document = newDocs.remove(at: index)
                    newDocs.insert(document, at: 0)
                }
            }
            return newDocs
        }
        return documents
    }
    
    private func processDriverLicenses(licenses: DSFullDocumentModel?) -> [DocumentModel] {
        let documents: [DocumentModel] = licenses?.data.filter({ $0.docData.validUntil == nil }).map {
            return DriverLicenseViewModelFactory().createViewModel(model: $0)
        } ?? []
        return reorderIfNeeded(documents: documents, orderIds: DocumentReorderingService.shared.order(for: DocType.driverLicense.rawValue))
    }
}

extension DocumentsProcessor: DocumentsProvider { }
