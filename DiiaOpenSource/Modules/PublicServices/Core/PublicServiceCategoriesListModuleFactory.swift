import Foundation
import DiiaMVPModule
import DiiaPublicServicesCore

struct PublicServiceCategoriesListModuleFactory {
    static func create() -> BaseModule {
        PublicServiceCategoriesListModule(context: .init(
            network: .create(),
            publicServiceRouteManager: .init(routeCreateHandlers: .publicServiceRouteCreateHandlers),
            storage: PublicServicesStorageImpl.init(storage: StoreHelper.instance),
            imageNameProvider: DSImageNameResolver.instance
        ))
    }
}

struct PublicServiceOpenerFactory {
    static func create() -> PublicServiceOpener {
        PublicServiceOpener(apiClient: PublicServicesAPIClient(context: .create()),
                            routeManager: .init(routeCreateHandlers: .publicServiceRouteCreateHandlers))
    }
}

private extension Dictionary {
    static var publicServiceRouteCreateHandlers: [ServiceTypeCode: PublicServiceRouteCreateHandler] {[
        PublicServiceType.criminalRecordCertificate.rawValue: { items in
            return PSCriminalRecordExtractRoute(contextMenuItems: items)
        }]}
}

class PublicServicesStorageImpl: PublicServicesStorage {
    private let storage: StoreHelperProtocol

    init(storage: StoreHelperProtocol) {
        self.storage = storage
    }

    func savePublicServicesResponse(response: PublicServiceResponse) {
        storage.save(response, type: PublicServiceResponse.self, forKey: .publicServiceListCache)
    }

    func getPublicServicesResponse() -> PublicServiceResponse? {
        storage.getValue(forKey: .publicServiceListCache)
    }
}
