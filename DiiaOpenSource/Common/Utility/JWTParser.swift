import Foundation
import DiiaCommonTypes

struct JWTToken: Decodable {
    private let data: String
    private let issuedAt: Int
    private let expiration: Int
    
    var issueDate: Date { return Date(timeIntervalSince1970: Double(issuedAt)) }
    var expirationDate: Date { return Date(timeIntervalSince1970: Double(expiration)) }
    var isExpired: Bool { expirationDate - Date() < JWTToken.expirationInterval }
    
    private enum CodingKeys: String, CodingKey {
        case data
        case issuedAt = "iat"
        case expiration = "exp"
    }
    
    // MARK: - Constants
    private static var expirationInterval: TimeInterval { EnvironmentVars.isInhouseMode ? 10.0 : 300.0 }
}

struct JWTParser {
    static func parse(_ rawToken: String) -> JWTToken? {
        guard let rawDataString = getRawDataString(from: rawToken) else { return nil }
        
        let paddedDataString = getPaddedDataString(from: rawDataString)
        
        guard let tokenData = Data(base64Encoded: paddedDataString) else { return nil }
        
        return try? JSONDecoder().decode(JWTToken.self, from: tokenData)
    }
    
    private static func getRawDataString(from token: String) -> String? {
        let tokenParts = token.components(separatedBy: JWTConstants.separator)
        
        guard tokenParts.indices.contains(JWTConstants.dataIndex) else { return nil }
        
        return tokenParts[JWTConstants.dataIndex]
    }
    
    private static func getPaddedDataString(from rawDataString: String) -> String {
        let paddingLength = rawDataString.count + ((rawDataString.count % JWTConstants.base64codingLength) % JWTConstants.base64codingLength)
        
        return rawDataString.padding(toLength: paddingLength, withPad: JWTConstants.padCharacter, startingAt: .zero)
    }
    
    private enum JWTConstants {
        static let dataIndex = 1
        static let separator = "."
        static let base64codingLength = 4
        static let padCharacter = "="
    }
}
