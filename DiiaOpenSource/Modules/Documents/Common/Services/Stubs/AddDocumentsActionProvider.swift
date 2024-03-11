import Foundation
import DiiaMVPModule
import DiiaCommonTypes
import DiiaDocumentsCommonTypes
import DiiaDocumentsCore

final class AddDocumentsActionProvider: AddDocumentsActionProviderProtocol {
    func action(for doc: DocsToAddModel, in view: BaseView, onDocumentAdded: Callback?, onDocumentExist: Callback?) -> Action? {
        return nil
    }
}
