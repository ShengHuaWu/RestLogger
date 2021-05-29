import Foundation

struct RestLogger {
    struct Content {
        let request: URLRequest
        let response: HTTPURLResponse?
        let data: Data?
        let error: Error?
        let id: UUID = .init() // TODO: This might not be a proper place
    }
    
    var record: (Content) -> Void
}

extension RestLogger.Content {
    var whole: String {
        let requestContent = request.content
        let responseContent = response?.content ?? ""
        let dataContent = data?.restResponseContent ?? ""
        let errorContent = error?.restErrorContent ?? ""
        
        return requestContent
            + "\n"
            + responseContent
            + "\n"
            + dataContent
            + "\n"
            + errorContent
    }
}

extension RestLogger {
    static let debug = Self { print($0.whole) }
    
    static let file = Self { content in
        guard let data = content.whole.data(using: .utf8) else {
            preconditionFailure("Fail to convert rest logging content to data.")
        }
        
        let url = global.getFileURL(content)
        do {
            try global.store(data, url)
        } catch {
            preconditionFailure("Fail to store rest logger content data at \(url) with error: \(error.localizedDescription)")
        }
    }
}
