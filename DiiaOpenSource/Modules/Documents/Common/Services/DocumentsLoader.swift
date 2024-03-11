import Foundation
import ReactiveKit
import DiiaDocumentsCommonTypes
import DiiaDocumentsCore

struct WeakReference<T: AnyObject> {
    weak var value: T?
}

class DocumentsLoader: NSObject, DocumentsLoaderProtocol {
    
    private let apiClient: DocumentsAPIClientProtocol
    private var storeHelper: StoreHelperProtocol
    private let orderService: DocumentReorderingServiceProtocol

    private var listeners: [WeakReference<DocumentsLoadingListenerProtocol>] = []

    private var irrelevantDocs: [DocTypeCode] = []
    private var isUpdating: Bool = false
    private var haveUpdates: Bool = false
    private var needUpdates: Bool = false

    override init() {
        fatalError("init() has not been implemented")
    }

    init(storage: StoreHelperProtocol,
         apiClient: DocumentsAPIClientProtocol,
         orderService: DocumentReorderingServiceProtocol) {
        self.storeHelper = storage
        self.apiClient = apiClient
        self.orderService = orderService
    }

    func setNeedUpdates() {
        if !isUpdating {
            updateIfNeeded()
        } else {
            needUpdates = true
        }
    }

    func updateIfNeeded() {
        if isUpdating {
            log("===> Already updating!")
            return
        }
        isUpdating = true
        haveUpdates = false

        checkDocumentsActuallity()

        let group = DispatchGroup()
        fetchDocs(in: group)

        group.notify(queue: .main) { [weak self] in
            defer {
                if self?.needUpdates == true {
                    self?.needUpdates = false
                    self?.updateIfNeeded()
                }
            }
            self?.isUpdating = false
            guard let self = self, self.haveUpdates else { return }
            self.haveUpdates = false
            self.listeners.forEach { $0.value?.documentsWasUpdated() }
        }
    }

    func addListener(listener: DocumentsLoadingListenerProtocol) {
        listeners.append(WeakReference(value: listener))
    }

    func removeListener(listener: DocumentsLoadingListenerProtocol) {
        listeners.removeAll(where: { $0.value === listener })
    }

    // MARK: - Checking
    private func checkDocumentsActuallity() {
        irrelevantDocs = []
        let order: [DocType] = orderService.docTypesOrder().compactMap { DocType(rawValue: $0) }

        for type in order {
            switch type {
            case .driverLicense:
                checkDoc(type: DSFullDocumentModel.self, docType: .driverLicense, storingKey: .driverLicense)
            case .taxpayerСard:
                irrelevantDocs.append(DocType.taxpayerСard.rawValue)
            }
        }
    }

    fileprivate func checkDoc<T>(type: T.Type, docType: DocType, storingKey: StoringKey) where T: StatusedExpirableProtocol {
        if let doc: T = storeHelper.getValue(forKey: storingKey) {
            log("\(docType.name) -> expiration date \(doc.expirationDate.toShortTimeString()). Current date - \(Date().toShortTimeString()).\(doc.expirationDate < Date() ? " Need update" : "")")
            if doc.expirationDate < Date() || doc.status == .documentProcessing {
                irrelevantDocs.append(docType.rawValue)
            }
        } else {
            irrelevantDocs.append(docType.rawValue)
        }
    }

    private func fetchDocs(in group: DispatchGroup) {
        guard irrelevantDocs.count > 0 else {
            return
        }

        group.enter()
        apiClient.getDocuments(irrelevantDocs).observe { [weak self] (event) in
            guard let self = self else { return }
            self.irrelevantDocs = []
            switch event {
            case .completed:
                break
            case .failed:
                group.leave()
            case .next(let documentsResponse):
                self.orderService.setOrder(order: documentsResponse.documentsTypeOrder ?? [], synchronize: false)
                self.saveDocs(documentsResponse: documentsResponse)
                self.actualizeLastDocUpdate()
                self.haveUpdates = true
                group.leave()
            }
        }.dispose(in: bag)
    }
    
    // MARK: - Saving
    func saveDoc<T>(_ doc: T?, type: T.Type, forKey key: StoringKey, orderType: DocType? = nil) where T: Codable&StatusedExpirableProtocol {
        if let doc = doc {
            if doc.status == .ok || doc.status == .notFound {
                storeHelper.save(doc, type: T.self, forKey: key)
                if let orderType = orderType { DocumentReorderingService.shared.cleanSynchronized(for: orderType.rawValue) }
            } else if var storedDoc: T = storeHelper.getValue(forKey: key) {
                storedDoc.expirationDate = doc.expirationDate
                storeHelper.save(storedDoc, type: T.self, forKey: key)
            } else {
                storeHelper.save(doc, type: T.self, forKey: key)
            }
        }
    }
    
    func saveDocs(documentsResponse: DocumentsResponse) {
        let driverLicense: DSFullDocumentModel? = storeHelper.getValue(forKey: .driverLicense)
        saveDoc(documentsResponse.driverLicense?.withLocalization(shareLocalization: driverLicense?.data.first?.shareLocalization ?? .ua),
                type: DSFullDocumentModel.self,
                forKey: .driverLicense,
                orderType: .driverLicense)
    }
    
    // MARK: - Helping
    private func actualizeLastDocUpdate() {
        let dateFormatter = Formatter.iso8601withFractionalSeconds
        let currentDateString = dateFormatter.string(from: Date())
        storeHelper.save(currentDateString, type: String.self, forKey: .lastDocumentUpdate)
    }
}
