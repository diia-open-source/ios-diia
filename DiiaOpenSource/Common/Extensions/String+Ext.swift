
import Foundation

extension String {
    func parseDecodable<T>(decoder: JSONDecoder = JSONDecoderConfig().jsonDecoder()) -> T? where T: Decodable {
        let data = Data(self.utf8)
        return try? decoder.decode(T.self, from: data)
    }
}
