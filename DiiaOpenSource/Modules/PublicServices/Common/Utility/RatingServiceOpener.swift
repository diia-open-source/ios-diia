import Foundation
import DiiaMVPModule
import DiiaCommonTypes

// MARK: - RateServiceProtocol
class RatingServiceOpener: RateServiceProtocol {
    func rateDiiaIdByRequest(serviceCode: String, form: PublicServiceRatingForm, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
    
    func ratePublicServiceByRequest(publicServiceType: String, form: PublicServiceRatingForm, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
    
    func ratePublicServiceByUser(publicServiceType: String, screenCode: String?, resourceId: String?, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
    
    func rateDocument(documentType: String, successCallback: ((AlertTemplate) -> Void)?, in view: BaseView) {}
}
