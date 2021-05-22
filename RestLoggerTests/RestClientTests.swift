import XCTest

@testable import RestLogger

final class RestClientTests: XCTestCase {
    private let restClient = RestClient()
    
    override func setUp() {
        super.setUp()
    }
    
    // TODO: This is more like an integration test rather than a unit test
    func testGetRequestFailsWhenParsingFails() {
        let e = expectation(description: #function)
        
        let url = URL(string: "https://developer.apple.com")!
        let getOperation = RestOperation<String> {
            RestRequest(url: url, method: .get)
        }
        
        restClient.perform(getOperation) { result in
            switch result {
            case .success:
                XCTFail("Request should fail.")
                
            case let .failure(error):
                guard case .parsingFailure = error else {
                    XCTFail("Error is something else: \(error.localizedDescription)")
                    return
                }
                
                e.fulfill()
            }
        }
        
        wait(for: [e], timeout: 5)
    }
}
