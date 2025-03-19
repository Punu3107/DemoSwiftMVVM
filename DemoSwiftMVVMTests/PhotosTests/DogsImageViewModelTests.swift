import XCTest
import Combine
@testable import DemoSwiftMVVM

final class DogsImageViewModelTests: XCTestCase {
    var dogsImageViewModel: DogsImageViewModel!
    var service: MockDogsImageRetrievalService!
    private var cancellables: Set<AnyCancellable>!
    var breedName: String!
    override func setUpWithError() throws {
        service = MockDogsImageRetrievalService()
        dogsImageViewModel = DogsImageViewModel(service: service)
        cancellables = []
        breedName = "african"
    }

    override func tearDownWithError() throws {
        dogsImageViewModel = nil
        service = nil
        cancellables = nil
    }

    func testDogsImageViewModelReturnsDogImages() async throws {
        try await dogsImageViewModel!.getDogImages(breedName: breedName)
        let list = dogsImageViewModel!.images
        
        // verify count
        XCTAssertGreaterThan(list.count, 0)
    }
    
    func testDogImagesProperty() throws {
        let expectation = XCTestExpectation(description: "@Published lists count")
        
        // initial state
        XCTAssertTrue(dogsImageViewModel!.images.isEmpty)
        
        dogsImageViewModel!
            .$images
            .dropFirst()
            .sink(receiveValue: { list in
                // verify count and fullfil the expectation
                XCTAssertGreaterThan(list.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        Task {
            try await dogsImageViewModel!.getDogImages(breedName: breedName)
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testDogsImageViewModelFailedGettingList() async {
        service.shouldFail = true
        
        do {
            try await dogsImageViewModel!.getDogImages(breedName: breedName)
            XCTFail("DogsImageViewModel should throw error.")
        } catch RequestError.failed(let error) {
            XCTAssertEqual(error, "No posts found.")
        } catch {
            XCTFail("DogsImageViewModel should throw RequestError.failed")
        }
    }
}

// MARK: - Mock

class MockDogsImageRetrievalService: DogsImageRetrievalService {
    
    var shouldFail: Bool = false
    
    func getDogsImage(breedName: String) async throws -> DogsImage {
        guard !shouldFail else {
            throw RequestError.failed(description: "No posts found.")
        }
        return try Bundle.test.decodableObject(forResource: "images", type: DogsImage.self)
    }
}
