import Foundation
import ReactiveKit
import DiiaNetwork

enum HttpStatusCode: Int {
    case unathorized = 401
}

struct HTTPStatusCodeAdapter: HTTPStatusCodeHandler {
    private let logoutSignal = PassthroughSubject<Void, Never>()
    private let bag = DisposeBag()
    init() {
        subscribeForLogout()
    }
    
    private func subscribeForLogout() {
        logoutSignal.debounce(for: 2).receive(on: DispatchQueue.main).observeNext {
            
        }.dispose(in: bag)
    }
    
    // This method is called in global queue
    func handleStatusCode(statusCode: Int) {
        if statusCode == HttpStatusCode.unathorized.rawValue {
            logoutSignal.send()
        }
    }
}
