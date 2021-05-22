import Foundation

struct RestRequest {
    let url: URL
    let method: RestMethod
    let headers: [String: String]
    let body: Data?
    
    init(url: URL, method: RestMethod, headers: [String: String] = [:], body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }
}

extension RestRequest {
    var urlRequest: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let existingHeaders = request.allHTTPHeaderFields, !headers.isEmpty {
            // Override values from the existing headers
            request.allHTTPHeaderFields = existingHeaders.merging(headers, uniquingKeysWith: { $1 })
        }
        
        request.httpBody = body
        
        return request
    }
}
