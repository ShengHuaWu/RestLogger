import Foundation

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
