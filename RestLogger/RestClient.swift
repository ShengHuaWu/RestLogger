import Foundation

enum RestClientError: Error {
    case networkFailure(Error)
    case invalidResponse(URLResponse?)
    case emptyData
    case parsingFailure(Error)
    case generic(message: String)
}

final class RestClient {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func perform<Resource>(_ operation: RestOperation<Resource>, _ completion: @escaping (Result<Resource, RestClientError>) -> Void) {
        let request = operation.buildRequest().urlRequest
        global.logger.pullback(\.content).record(request)
        
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else {
                completion(.failure(.generic(message: "RestClient instance has been deallocated already before the response comes back")))
                return
            }
            
            do {
                let unwrappedData = try strongSelf.sanitize(data: data, response: response, error: error)
                let resource = try operation.parse(unwrappedData)
                completion(.success(resource))
            } catch let error as RestClientError {
                completion(.failure(error))
            } catch let error {
                completion(.failure(.parsingFailure(error)))
            }
        }
        task.resume()
    }
    
    private func sanitize(data: Data?, response: URLResponse?, error: Error?) throws -> Data {
        if let unwrappedError = error {
            global.logger.pullback(\.restErrorContent).record(unwrappedError)
            throw RestClientError.networkFailure(unwrappedError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            let invalidResponseError = RestClientError.invalidResponse(response)
            global.logger.pullback(\.restErrorContent).record(invalidResponseError)
            throw invalidResponseError
        }
        
        global.logger.pullback(\.content).record(httpResponse)
        
        // It might be necessary to parse the data for error as well
        
        guard let unwrappedData = data else {
            throw RestClientError.emptyData
        }
        
        global.logger.pullback(\.restResponseContent).record(unwrappedData)
        
        return unwrappedData
    }
}
