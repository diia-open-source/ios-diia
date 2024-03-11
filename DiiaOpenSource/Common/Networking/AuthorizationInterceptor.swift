import Foundation
import Alamofire
import DiiaNetwork

class AuthorizationInterceptor: RequestInterceptor {
    
    typealias AdaptCompletion = (Result<URLRequest, Error>) -> Void
    
    private let refreshTokenlock = NSRecursiveLock()
    
    private var lastRefreshTokenTime: Date?
    private var retryCompletionBlocks: [(RetryResult) -> Void] = []
    private var isRefreshing = false
    
    private var adapts: [(completion: AdaptCompletion, request: URLRequest)] = []
    private var isAdapting = false
    private let adaptingLock = NSRecursiveLock()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard
            let savedToken = ServicesProvider.shared.authService.token,
            let jwtToken = JWTParser.parse(savedToken)
        else {
            completion(.success(urlRequest))
            return
        }
        
        guard jwtToken.isExpired else {
            var request = urlRequest
            request.setValue("bearer \(savedToken)", forHTTPHeaderField: "Authorization")
            completion(.success(request))
            
            return
        }
        
        adaptingLock.lock()
        defer { adaptingLock.unlock() }
        
        adapts.append((completion, urlRequest))
        guard isAdapting == false else { return }
        
        isAdapting = true
        resfreshToken()
    }
    
    private func resfreshToken() {
        ServicesProvider.shared.authService.refresh { [unowned self] (err) in
            self.adaptingLock.lock()
            
            defer {
                self.adaptingLock.unlock()
                self.isAdapting = false
            }
            
            if let error = err {
                self.adapts.forEach { $0.completion(.failure(error)) }
                self.adapts.removeAll()
                return
            }
            
            guard let token = ServicesProvider.shared.authService.token else {
                self.adapts.forEach { $0.completion(.failure(NetworkError.noData)) }
                self.adapts.removeAll()
                return
            }

            self.adapts.forEach { (completion, request) in
                var adaptedRequest = request
                adaptedRequest.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
                completion(.success(adaptedRequest))
            }
            
            self.adapts.removeAll()
        }
    }

    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        refreshTokenlock.lock()
        defer { refreshTokenlock.unlock() }
        guard let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == AppConstants.HttpCode.unauthorized else {
                completion(.doNotRetry)
                return
        }
        
        // check the current refreshing style
        guard Date().timeIntervalSince(lastRefreshTokenTime ?? Date(timeIntervalSince1970: 0)) > 60 else {
            completion(.doNotRetry)
            return
        }
        retryCompletionBlocks.append(completion)
        guard !isRefreshing else {
            return
        }
        
        if let url = request.request?.url, EnvironmentVars.isInDebug {
            log("Trying refresh token for request url:\n\(url)")
        }
        isRefreshing = true
        ServicesProvider.shared.authService.refresh(completion: { [unowned self] error in
            self.refreshTokenlock.lock()
            defer { self.refreshTokenlock.unlock() }
            let success = (error == nil && ServicesProvider.shared.authService.isAuthorized())
            if success {
                self.lastRefreshTokenTime = Date()
                self.retryCompletionBlocks.forEach { $0(.retry) }
            } else {
                self.retryCompletionBlocks.forEach { $0(.doNotRetry) }
            }
            
            if EnvironmentVars.isInDebug {
                success ? print("Refresh success") : print("Refresh failed: \(String(describing: error))")
            }
            
            self.retryCompletionBlocks.removeAll()
            self.isRefreshing = false
        })
        
    }

}
