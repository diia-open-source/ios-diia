import UIKit
import DiiaMVPModule
import DiiaDocumentsCommonTypes

protocol DocumentsStackReorderingAction: BasePresenter {
    func onBackTapped()
    func numberOfItems() -> Int
    func item(at index: Int) -> DocReorderingCellViewModel
    func moveItem(from index: Int, toIndex: Int)
}

final class DocumentsStackReorderingPresenter: DocumentsStackReorderingAction {

	// MARK: - Properties
    unowned var view: DocumentsStackReorderingView
    private let orderService: DocumentReorderingService

    private let docType: DocType
    private var documents: [DocumentModel]
    private let initialOrder: [String]
    
    // MARK: - Init
    init(view: DocumentsStackReorderingView, docType: DocType) {
        self.view = view
        self.orderService = DocumentReorderingService.shared
        self.docType = docType
        self.documents = DocumentsProcessor()
            .documents(with: [docType.docCode], actionView: nil)
            .flatMap { $0.getValues() }
        self.initialOrder = documents.compactMap { $0.orderIdentifier }
    }
    
    // MARK: - Public Methods
    func configureView() {
        view.setTitle(docType.stackName)
    }
    
    func numberOfItems() -> Int {
        return documents.count
    }
    
    func item(at index: Int) -> DocReorderingCellViewModel {
        let selectedDoc = documents[index]
        return DocReorderingCellViewModel(
            documentItem: DocReorderingCellInfoViewModel(
                title: selectedDoc.orderConfigurations?.label ?? "",
                subtitle: selectedDoc.orderConfigurations?.description,
                rightIcon: R.image.ds_drag.image)
        )
    }
    
    func moveItem(from index: Int, toIndex: Int) {
        let item = documents.remove(at: index)
        documents.insert(item, at: toIndex)
    }
    
    func onBackTapped() {
        saveDocumentsInOrder()
        view.closeModule(animated: true)
    }
    
    // MARK: - Private Methods
    private func saveDocumentsInOrder() {
        let newOrder = documents.compactMap { $0.orderIdentifier }
        guard newOrder != initialOrder else { return }
        orderService.setOrder(order: newOrder, for: docType.docCode)
    }
}
