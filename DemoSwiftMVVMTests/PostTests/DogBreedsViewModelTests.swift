import XCTest
import Combine
@testable import DemoSwiftMVVM

final class DogBreedsViewModelTests: XCTestCase {
    var dogBreedsViewModel: DogBreedsViewModel!
    var dogsBreedService: MockDogsBreedListService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        dogsBreedService = MockDogsBreedListService()
        dogBreedsViewModel = DogBreedsViewModel(dogsBreedListService: dogsBreedService)
        cancellables = []
    }

    override func tearDownWithError() throws {
        dogBreedsViewModel = nil
        dogsBreedService = nil
        cancellables = nil
    }

    func testDogBreedsViewModelReturnsDogList() async throws {
        try await dogBreedsViewModel!.loadDogsBreedData()
        let list = dogBreedsViewModel!.dogsBreedList
        
        // verify count
        XCTAssertGreaterThan(list.count, 0)
        
        let first = try XCTUnwrap(list.first)
        XCTAssertEqual(first, "affenpinscher")
        
        let last = try XCTUnwrap(list.last)
        XCTAssertEqual(last, "wolfhound")
    }
    
    func testDogBreedsListProperty() throws {
        let expectation = XCTestExpectation(description: "@Published lists count")
        
        // initial state
        XCTAssertTrue(dogBreedsViewModel!.dogsBreedList.isEmpty)
        
        dogBreedsViewModel!
            .$dogsBreedList
            .dropFirst()
            .sink(receiveValue: { list in
                // verify count and fullfil the expectation
                XCTAssertGreaterThan(list.count, 0)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        Task {
            try await dogBreedsViewModel!.loadDogsBreedData()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func testDogBreedsViewModelFailedGettingList() async {
        dogsBreedService.shouldFail = true
        
        do {
            try await dogBreedsViewModel!.loadDogsBreedData()
            XCTFail("DogBreedsViewModel should throw error.")
        } catch RequestError.failed(let error) {
            XCTAssertEqual(error, "No posts found.")
        } catch {
            XCTFail("DogBreedsViewModel should throw RequestError.failed")
        }
    }
}

// MARK: - Mock

class MockDogsBreedListService: DogsBreedListService {
    var shouldFail: Bool = false
    
    func getDogsBreedList() async throws -> DogBreeds {
        guard !shouldFail else {
            throw RequestError.failed(description: "No posts found.")
        }
        return try Bundle.test.decodableObject(forResource: "breed", type: DogBreeds.self)
    }
}
