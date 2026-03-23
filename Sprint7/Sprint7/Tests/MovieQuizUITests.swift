import XCTest
@testable import Sprint7

struct StubNetworkClient: NetworkClientProtocol {
    enum TestError: Error { case test }
    let emulateError: Bool
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        if emulateError {
            handler(.failure(TestError.test))
        } else {
            let json = """
            {"errorMessage": "", "items":}
            """
            handler(.success(Data(json.utf8)))
        }
    }
}

final class MoviesLoaderTests: XCTestCase {
    func testSuccessLoading() {
        let loader = MoviesLoader(networkClient: StubNetworkClient(emulateError: false))
        let expectation = expectation(description: "Loading expectation")
        
        loader.loadMovies { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.items.count, 1)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected failure")
            }
        }
        waitForExpectations(timeout: 1)
    }
}
