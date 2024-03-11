import Foundation
import ReactiveKit
import DiiaCommonTypes
import DiiaCommonServices
import DiiaDocumentsCommonTypes
import DiiaDocumentsCore

class DocumentReorderingService: DocumentReorderingServiceProtocol {

    static let shared = DocumentReorderingService(store: StoreHelper.instance)
    
    private let store: StoreHelperProtocol
    private let apiClient = DocumentReorderingAPIClient()
    private let bag = DisposeBag()
    
    private init(store: StoreHelperProtocol) {
        self.store = store
        
        ReachabilityHelper.shared
            .statusSignal
            .observeNext { [weak self] isReachable in if isReachable { self?.synchronizeIfNeeded() } }
            .dispose(in: bag)
    }
    
    // MARK: - DocumentReorderingServiceProtocol
    func docTypesOrder() -> [DocTypeCode] {
        let order: [DocType] = store.getValue(forKey: .docsOrderUnsynchronized)
        ?? store.getValue(forKey: .docsOrder)
        ?? DocType.allCardTypes
        
        return order.map({ $0.rawValue })
    }
    
    func setOrder(order: [DocTypeCode], synchronize: Bool) {
        let docTypeOrder = order.compactMap({ DocType(rawValue: $0) })
        
        var newOrder = docTypeOrder
        for doc in DocType.allCardTypes {
            if !docTypeOrder.contains(doc) {
                newOrder.append(doc)
            }
        }
        let storedOrder = docTypesOrder().compactMap({ DocType(rawValue: $0) })
        if newOrder == storedOrder { return }
        store.save(newOrder, type: [DocType].self, forKey: .docsOrder)
        guard synchronize else { return }
        store.save(newOrder, type: [DocType].self, forKey: .docsOrderUnsynchronized)
        NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
        synchronizeIfNeeded()
    }
    
    func order(for type: DocTypeCode) -> [String] {
        guard let docType = DocType(rawValue: type) else { return [] }
        
        if let order: [DocType: [String]] = store.getValue(forKey: .docsStackOrderUnsynchronized),
           let docOrder = order[docType] {
            return docOrder
        }
        guard let order: [DocType: [String]] = store.getValue(forKey: .docsStackOrder) else { return [] }
        return order[docType] ?? []
    }
    
    func setOrder(order: [String], for type: DocTypeCode) {
        guard let docType = DocType(rawValue: type) else { return }

        var unsynchronizedOrder: [DocType: [String]] = store.getValue(forKey: .docsStackOrderUnsynchronized) ?? [:]
        var synchronizedOrder: [DocType: [String]] = store.getValue(forKey: .docsStackOrder) ?? [:]

        unsynchronizedOrder[docType] = order
        synchronizedOrder[docType] = order
        store.save(synchronizedOrder, type: [DocType: [String]].self, forKey: .docsStackOrder)
        store.save(unsynchronizedOrder, type: [DocType: [String]].self, forKey: .docsStackOrderUnsynchronized)
        NotificationCenter.default.post(name: AppConstants.Notifications.documentsWasReordered, object: nil)
        synchronizeIfNeeded()
    }
    
    func synchronizeIfNeeded() {
        if let order: [DocType] = store.getValue(forKey: .docsOrderUnsynchronized) {
            apiClient.sendDocumentsOrder(order: order).observe { [weak self] (event) in
                switch event {
                case .next:
                    self?.store.removeValue(forKey: .docsOrderUnsynchronized)
                case .failed(let err):
                    log(err)
                case .completed:
                    break
                }
            }.dispose(in: bag)
        }
        
        if let order: [DocType: [String]] = store.getValue(forKey: .docsStackOrderUnsynchronized) {
            var needUpdates = false
            var newStackOrder: [DocType: [String]] = [:]
            let group = DispatchGroup()
            newStackOrder = order
            for type in order.keys {
                if let unsavedOrder = order[type] {
                    needUpdates = true
                    group.enter()
                    apiClient.sendOrder(order: unsavedOrder, for: type).observe { (event) in
                        switch event {
                        case .next:
                            newStackOrder[type] = nil
                            group.leave()
                        case .failed(let err):
                            log(err)
                            group.leave()
                        case .completed:
                            break
                        }
                    }.dispose(in: bag)
                }
            }
            guard needUpdates else { return }
            group.notify(queue: .main) {
                self.store.save(newStackOrder, type: [DocType: [String]].self, forKey: .docsStackOrderUnsynchronized)
            }
        }
    }
    
    func cleanSynchronized(for type: DocTypeCode) {
        guard let docType = DocType(rawValue: type) else { return }
        if var order: [DocType: [String]] = store.getValue(forKey: .docsStackOrder) {
            order[docType] = nil
            self.store.save(order, type: [DocType: [String]].self, forKey: .docsStackOrder)
        }
    }
    
    func updateOrdersIfNeeded() {
        if let order: [DocType] = store.getValue(forKey: .docsOrder) {
            setOrder(order: order.map({ $0.rawValue }), synchronize: false)
        }
    }
}
