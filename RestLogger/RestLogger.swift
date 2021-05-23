import Foundation

struct RestLogger {
    struct Content {
        let request: URLRequest
        let response: HTTPURLResponse?
        let data: Data?
        let error: Error?
    }
    
    var record: (Content) -> Void
}

extension RestLogger {
    static let debug = Self(
        record: { content in
            print(content.request.content)
            print(content.response?.content ?? "")
            print(content.data?.restResponseContent ?? "")
            print(content.error?.restErrorContent ?? "")
        }
    )
}
