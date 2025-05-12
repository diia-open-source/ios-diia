import Foundation
import DiiaDocuments
import DiiaDocumentsCommonTypes

struct DriverLicenseViewModelFactory {
    func createViewModel(model: DSDocumentData) -> DriverLicenseViewModel {
        
        let context = DriverLicenseContext(model: model,
                                           docType: DocType.driverLicense,
                                           reservePhotoService: DocumentsReservePhotoService(),
                                           sharingApiClient: SharingDocsAPIClient(),
                                           ratingOpener: RatingServiceOpener(),
                                           faqOpener: FaqOpener(),
                                           appRouter: AppRouter.instance,
                                           replacementModule: nil,
                                           docReorderingModule: { DocumentsReorderingModule() },
                                           docStackReorderingModule: { DocumentsStackReorderingModule(docType: .driverLicense) },
                                           storeHelper: DriverLicenseDocumentStorageImpl(storage: StoreHelper.instance),
                                           urlHandler: URLOpenerImpl()
        )
        
        return DriverLicenseViewModel(context: context)
    }
}

class DriverLicenseDocumentStorageImpl: DriverLicenseDocumentStorage {
    private let storage: StoreHelperProtocol

    init(storage: StoreHelperProtocol) {
        self.storage = storage
    }

    func saveDriverLicense(document: DSFullDocumentModel) {
        storage.save(document, type: DSFullDocumentModel.self, forKey: .driverLicense)
    }

    func getDriverLicenseDocument() -> DSFullDocumentModel? {
        storage.getValue(forKey: .driverLicense)
    }
}
