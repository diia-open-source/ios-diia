import UIKit
import DiiaMVPModule
import DiiaDocumentsCommonTypes

protocol DocumentsReorderingAction: BasePresenter {
    func onBackTapped()
    func numberOfItems() -> Int
    func item(at index: Int) -> DocReorderingCellViewModel
    func moveItem(from index: Int, toIndex: Int)
}

final class DocumentsReorderingPresenter: DocumentsReorderingAction {
    unowned var view: DocumentsReorderingView
    private let orderService: DocumentReorderingService

    private var documents: [MultiDataType<DocumentModel>]

    // MARK: - Init
    init(view: DocumentsReorderingView) {
        self.view = view
        self.orderService = DocumentReorderingService.shared
        self.documents = DocumentsProcessor().documents(with: orderService.docTypesOrder(), actionView: nil)
    }

    // MARK: - Public Methods
    func numberOfItems() -> Int {
        return documents.count
    }

    func item(at index: Int) -> DocReorderingCellViewModel {
        let selectedDocuments = documents[index].getValues()
        let selectedDoc = documents[index].getValue()

        return DocReorderingCellViewModel(
            documentItem: DocReorderingCellInfoViewModel(
                title: selectedDoc.documentName ?? "",
                subtitle: nil,
                rightIcon: R.image.ds_drag.image),
            multipleDocItem: (selectedDocuments.count < 2) ? nil : MultipleDocReorderingViewModel(
                leftIcon: R.image.ds_stack.image,
                numberOfDocuments: selectedDocuments.count,
                rightIcon: R.image.ds_ellipseArrowRight.image,
                touchAction: { [weak self] in
                    guard let docTypeCode = selectedDoc.docType?.docCode, let docType = DocType(rawValue: docTypeCode) else { return }
                    self?.view.open(module: DocumentsStackReorderingModule(docType: docType))
                }
            )
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
        orderService.setOrder(order: documents.compactMap { $0.getValue().docType?.docCode }, synchronize: true)
    }
}
