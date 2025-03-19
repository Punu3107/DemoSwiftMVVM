import XCTest
import Combine
@testable import DemoSwiftMVVM

final class DogsImageServiceTests: XCTestCase {
    var dogsImageService: DogsImageService?
    var breedName: String!

    override func setUpWithError() throws {
        breedName = "african"
        dogsImageService = DogsImageService(networkManager: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        dogsImageService = nil
    }

    func test_DogsImageService_GetDogsImageList() async throws {
        let dogsImages = try await dogsImageService!.getDogsImage(breedName:breedName)
        XCTAssertGreaterThan(dogsImages.message.count, 0, "Images array not nil")
    }
    
    func testPostServiceThrowsError() async throws {
        // TODO: How to implement this?
    }
}

// MARK: - Mock

fileprivate class MockNetworkManager: NetworkHandler {
    
    func fetch<T>(request: Request) async throws -> T where T : Decodable {
        try Bundle.test.decodableObject(forResource: "images", type: T.self)
    }
    
    func fetch<T>(request: Request) -> AnyPublisher<T, RequestError> where T : Decodable {
        do {
            let images = try Bundle.test.decodableObject(forResource: "images", type: T.self)
            return Just(images)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
            
        } catch {
            return Fail(error: RequestError.failed(description: error.localizedDescription))
                .eraseToAnyPublisher()
        }
    }
}
