import XCTest
import Combine
@testable import DemoSwiftMVVM

final class DogsBreedServiceTests: XCTestCase {
    var dogsBreedService: DogsBreedService?

    override func setUpWithError() throws {
        dogsBreedService = DogsBreedService(networkManager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        dogsBreedService = nil
    }

    func test_DogsBreedService_GetDogsBreedList() async throws {
        let dogsBreed = try await dogsBreedService!.getDogsBreedList()
        
        let firstBreed = try XCTUnwrap(dogsBreed.message.first)
        XCTAssertEqual(firstBreed, "affenpinscher")
        
        let lastBreed = try XCTUnwrap(dogsBreed.message.last)
        XCTAssertEqual(lastBreed, "wolfhound")
    }
    
    func testPostServiceThrowsError() async throws {
        // TODO: How to implement this?
    }
}

// MARK: - Mock

fileprivate class MockNetworkManager: NetworkHandler {
    
    func fetch<T>(request: Request) async throws -> T where T : Decodable {
        try Bundle.test.decodableObject(forResource: "breed", type: T.self)
    }
    
    func fetch<T>(request: Request) -> AnyPublisher<T, RequestError> where T : Decodable {
        do {
            let breedList = try Bundle.test.decodableObject(forResource: "breed", type: T.self)
            return Just(breedList)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: RequestError.failed(description: error.localizedDescription))
                .eraseToAnyPublisher()
        }
    }
}
