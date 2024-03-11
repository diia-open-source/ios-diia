import Foundation
import ReactiveKit

protocol BaseBindingExecutablePresenter: BindingExecutionContextProvider {}

extension BaseBindingExecutablePresenter {
    var bindingExecutionContext: ExecutionContext {
        return .immediateOnMain
    }
}
