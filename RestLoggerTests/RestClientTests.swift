import XCTest

@testable import RestLogger

final class RestClientTests: XCTestCase {
    private var restClient: RestClient!
    
    override func setUp() {
        super.setUp()
        
        global = .test
        
        restClient = RestClient()
    }
    
    // TODO: This is more like an integration test rather than a unit test
    func testGetRequestFailsWhenParsingFails() {
        let e = expectation(description: #function)
        
        var recordCallCount = 0
        global.logger.record = { _ in
            recordCallCount += 1
        }
        
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
                
                XCTAssertEqual(recordCallCount, 3)
                e.fulfill()
            }
        }
        
        wait(for: [e], timeout: 5)
    }
}
