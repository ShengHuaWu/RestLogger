import Foundation

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
