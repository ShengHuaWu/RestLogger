import Foundation

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
