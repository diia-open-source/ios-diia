//___FILEHEADER___

import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices

protocol ___FILEBASENAMEASIDENTIFIER___Protocol {
    func getOnboarding() -> Signal<DSConstructorModel, NetworkError>
    func getMainScreen() -> Signal<DSConstructorModel, NetworkError>
    func getStatusScreen(applicationId: String) -> Signal<DSConstructorModel, NetworkError>
}

class ___FILEBASENAMEASIDENTIFIER___: ApiClient<___VARIABLE_productName:identifier___API>, ___FILEBASENAMEASIDENTIFIER___Protocol {

    func getOnboarding() -> Signal<DSConstructorModel, NetworkError> {
        return request(.getOnboarding)
    }
    
    func getMainScreen() -> Signal<DSConstructorModel, NetworkError> {
        return request(.getMainScreen)
    }
    
    func getStatusScreen(applicationId: String) -> Signal<DSConstructorModel, NetworkError> {
        return request(.getStatusScreen(applicationId: applicationId))
    }
}
