
import ReactiveKit
import DiiaNetwork
import DiiaCommonTypes
import DiiaUIComponents
import DiiaCommonServices

protocol FeedAPIClientProtocol {
    func getFeedScreen() -> Signal<DSConstructorModel, NetworkError>
    func getFeedNewsScreen() -> Signal<DSConstructorModel, NetworkError>
    func getFeedNews(pagination: PaginationModel) -> Signal<TemplatedResponse<FeedNewsResponse>, NetworkError>
    func getNewsDetails(id: String) -> Signal<DSConstructorModel, NetworkError>
}

class FeedAPIClient: ApiClient<FeedAPI>, FeedAPIClientProtocol {
    func getFeedScreen() -> Signal<DSConstructorModel, NetworkError> {
        return request(.getFeed)
    }
    
    func getFeedNewsScreen() -> Signal<DSConstructorModel, NetworkError> {
        return request(.getNewsScreen)
    }
    
    func getFeedNews(pagination: PaginationModel) -> Signal<TemplatedResponse<FeedNewsResponse>, NetworkError> {
        return request(.getNews(pagination: pagination))
    }
    
    func getNewsDetails(id: String) -> Signal<DSConstructorModel, NetworkError> {
        return request(.getNewsDetails(id: id))
    }
}
