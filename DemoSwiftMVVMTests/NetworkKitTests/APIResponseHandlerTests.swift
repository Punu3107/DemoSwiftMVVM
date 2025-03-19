import XCTest
@testable import DemoSwiftMVVM

final class APIResponseHandlerTests: XCTestCase {
    var responseHandler: ResponseHandler!
    
    override func setUpWithError() throws {
        responseHandler = APIResponseHandler()
    }

    override func tearDownWithError() throws {
        responseHandler = nil
    }
    
    func testAPIResponseHandlerParseSuccess() throws {
        let postData = MockResponse.postData
        
        let result: DogBreedsModel = try responseHandler!.getResponse(from: postData)
        XCTAssertGreaterThan(result.message.count, 0)
        XCTAssertEqual(result.status, "success")
    }
    
    func testAPIResponseHandlerParseFailure() throws {
        let dummyData = MockResponse.dummyData
        let expectation = XCTestExpectation(description: "APIResponseHandler throws decode error")
        
        do {
            let _: DogBreeds = try responseHandler!.getResponse(from: dummyData)
            XCTFail("APIResponseHandler should throw decode error")
        } catch RequestError.decode {
            expectation.fulfill()
        }
    }
}

// MARK: - Model
struct DogBreedsModel: Decodable {
    let message: [String]
    let status: String
}
