import Foundation
import DiiaCommonTypes
import DiiaMVPModule
import DiiaNetwork
import DiiaPublicServices
import DiiaCommonServices

extension NetworkingContext {
    static func create() -> NetworkingContext {
        .init(session: NetworkConfiguration.default.session,
              host: EnvironmentVars.apiHost,
              headers: ["App-Version": AppConstants.App.appVersion,
                        "Platform-Type": AppConstants.App.platform,
                        "Platform-Version": AppConstants.App.iOSVersion,
                        "mobile_uid": AppConstants.App.mobileUID,
                        "User-Agent": AppConstants.App.userAgent])
        
    }
}

struct PSCriminalRecordExtractRoute: RouterProtocol {
    private let contextMenuItems: [ContextMenuItem]
    
    init(contextMenuItems: [ContextMenuItem]) {
        self.contextMenuItems = contextMenuItems
    }
    
    func route(in view: BaseView) {
        let baseCMP = BaseContextMenuProvider(publicService: .criminalRecordCertificate, items: contextMenuItems)
        let config: PSCriminalRecordExtractConfiguration = .init(ratingServiceOpener: RatingServiceOpener(),
                                                                 networkingContext: .create(),
                                                                 urlOpener: URLOpenerImpl())
        
        view.open(module: CriminalExtractListModule(contextMenuProvider: baseCMP, сonfig: config))
    }
}
