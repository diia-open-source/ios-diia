import Foundation
import DiiaNetwork

struct JSONDecoderConfig: JSONDecoderConfigProtocol {
    let dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .customISO8601
    let dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData
    let nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
    let keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys
    
    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = dataDecodingStrategy
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy
        
        return decoder
    }
}
