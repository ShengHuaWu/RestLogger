import Foundation

struct RestLogger<Content> {
    var record: (Content) -> Void
}

extension RestLogger {
    func pullback<NewContent>(_ f: @escaping (NewContent) -> Content) -> RestLogger<NewContent> {
        .init { newContent in
            self.record(f(newContent))
        }
    }
    
    func pullback<NewContent>(_ keypath: KeyPath<NewContent, Content>) -> RestLogger<NewContent> {
        pullback { $0[keyPath: keypath] }
    }
}

extension RestLogger where Content == String {
    static let debug = Self(
        record: { content in
            print(content)
        })
}

extension URLRequest {
    var content: String {
        let urlString = url?.absoluteString ?? ""
        let method = httpMethod ?? ""
        let headers = allHTTPHeaderFields ?? [:]
        let body = httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: []) }.debugDescription
        
        return """
        REST Request:
        - url: \(urlString)
        - method: \(method)
        - headers: \(headers)
        - body: \(body)
        """
    }
}

extension HTTPURLResponse {
    var content: String {
        let urlString = url?.absoluteString ?? ""
        
        return """
        REST HTTP Response:
        - url: \(urlString)
        - statusCode: \(statusCode)
        - headers: \(allHeaderFields)
        """
    }
}

extension Error {
    var restErrorContent: String {
        """
        REST Error:
        \(localizedDescription)
        """
    }
}

extension Data {
    var restResponseContent: String {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
            return """
            REST Response Data:
            - json: \(json.debugDescription)
            """
        }

        if let text = String(data: self, encoding: .utf8) {
            return """
            REST Response Data:
            - utf8 string: \(text)
            """
        }
        
        return """
        REST Response Data:
        Unable to parse the response data into JSON or UTF8 string.
        The length of the data is `\(count)`.
        """
    }
}
