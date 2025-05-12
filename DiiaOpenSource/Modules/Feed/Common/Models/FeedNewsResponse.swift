
import Foundation
import DiiaUIComponents

struct FeedNewsResponse: Codable {
    let items: [DSHalvedCardCarouselItem]
    let total: Int?
}
