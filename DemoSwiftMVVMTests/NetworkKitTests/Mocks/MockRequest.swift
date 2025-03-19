import Foundation
@testable import DemoSwiftMVVM

public struct MockDogsListRequest: Request {
    public var scheme: String { "https" }
    public var host: String { "dog.ceo" }
    public var path: String { "/api/breeds/list" }
    
    var url: URL? {
        try? createURLRequest().url
    }
}
