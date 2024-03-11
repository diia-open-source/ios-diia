import Foundation
import Alamofire
import DiiaNetwork

// MARK: - SSL Pinning

extension NetworkConfiguration {
    
    enum SchemeType: String {
        case prod = "DiiaProd"
        case dev = "DiiaDev"
    }
    
    enum NetworkConstants {
        static let devBase64 = "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" // swiftlint:disable:this line_length
        
        static let prodBase64 = "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" // swiftlint:disable:this line_length
    }
    
    func devPinnedCertificatesTrustEvaluator() -> PinnedCertificatesTrustEvaluator {
        if let certificateData = Data(base64Encoded: NetworkConstants.devBase64, options: []),
            let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
            let trustEvaluator = PinnedCertificatesTrustEvaluator(certificates: [certificate],
                                                                  acceptSelfSignedCertificates: true,
                                                                  performDefaultValidation: false,
                                                                  validateHost: false)
                return trustEvaluator
            }
        return PinnedCertificatesTrustEvaluator()
    }
    
    func prodPinnedCertificatesTrustEvaluator() -> PinnedCertificatesTrustEvaluator {
        var certs: [SecCertificate] = []
        if let certificateData = Data(base64Encoded: NetworkConstants.prodBase64, options: []),
            let oldCertificate = SecCertificateCreateWithData(nil, certificateData as CFData) {
            certs.append(oldCertificate)
        }
        let trustEvaluator = PinnedCertificatesTrustEvaluator(certificates: certs)
        return trustEvaluator
    }
    
    func activeServerTrustPolicies() -> [String: ServerTrustEvaluating] {
        let activeScheme = SchemeType(rawValue: EnvironmentVars.scheme)
        var currentCertTrustEvaluator: ServerTrustEvaluating
        
        switch activeScheme {
        case .dev:
            currentCertTrustEvaluator = DisabledTrustEvaluator()
        case .prod:
            currentCertTrustEvaluator = prodPinnedCertificatesTrustEvaluator()
        default:
            currentCertTrustEvaluator = DisabledTrustEvaluator()
        }
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
            EnvironmentVars.baseApiHost: currentCertTrustEvaluator
        ]
        return serverTrustPolicies
    }
}
