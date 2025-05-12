
import Foundation
import DiiaNetwork
import DiiaCommonServices

enum FeedAPI: CommonService {
    
    case getFeed
    case getNewsScreen
    case getNews(pagination: PaginationModel)
    case getNewsDetails(id: String)
    
    var method: HTTPMethod {
        switch self {
        case .getFeed,
             .getNewsScreen,
             .getNews,
             .getNewsDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getFeed:
            return "v1/feed"
        case .getNewsScreen:
            return "v1/feed/news/screen"
        case .getNews:
            return "v1/feed/news"
        case .getNewsDetails(let id):
            return "v1/feed/news/\(id)"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getFeed,
             .getNewsScreen,
             .getNewsDetails,
             .getNews:
            return nil
        }
    }
    
    var analyticsName: String { return "" }
}
