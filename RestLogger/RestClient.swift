import Foundation

enum RestClientError: Error {
    case networkFailure(Error)
    case invalidResponse(URLResponse?)
    case emptyData
    case parsingFailure(Error)
    case generic(message: String)
}

final class RestClient {
    func perform<Resource>(_ operation: RestOperation<Resource>, _ completion: @escaping (Result<Resource, RestClientError>) -> Void) {
        let request = operation.buildRequest().urlRequest
        
        let task = global.urlSession.dataTask(with: request) { [weak self] data, response, error in
            let content = RestLogger.Content(request: request,
                                             response: response as? HTTPURLResponse,
                                             data: data,
                                             error: error)
            global.logger.record(content)
            
            guard let strongSelf = self else {
                completion(.failure(.generic(message: "RestClient instance has been deallocated already before the response comes back")))
                return
            }
            
            do {
                let unwrappedData = try strongSelf.sanitize(data: data, response: response, error: error)
                let resource = try operation.parse(unwrappedData)
                completion(.success(resource))
                
            // TODO: Shall we record the following errors as well?
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
            throw RestClientError.networkFailure(unwrappedError)
        }
        
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            let invalidResponseError = RestClientError.invalidResponse(response)
            throw invalidResponseError
        }
        
        // It might be necessary to parse the data for error as well
        
        guard let unwrappedData = data else {
            throw RestClientError.emptyData
        }
                
        return unwrappedData
    }
}
