import XCTest
@testable import Sprint7

final class MoviesLoaderTests: XCTestCase {

    struct StubNetworkClient: NetworkClientProtocol {
        let emulateError: Bool
        
        func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
            if emulateError {
                handler(.failure(TestError.test))
            } else {
                let expectedJson = """
                {
                   "errorMessage" : "",
                   "items" : []
                }
                """
                let data = expectedJson.data(using: .utf8) ?? Data()
                handler(.success(data))
            }
        }
    }
    enum TestError: Error {
        case test
    }
    
    func testSuccessLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: false)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(_):
                XCTFail("Unexpected failure")
            }
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testFailureLoading() throws {
        let stubNetworkClient = StubNetworkClient(emulateError: true)
        let loader = MoviesLoader(networkClient: stubNetworkClient)
        
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .failure(_):
                expectation.fulfill()
            case .success(_):
                XCTFail("Unexpected success")
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}

