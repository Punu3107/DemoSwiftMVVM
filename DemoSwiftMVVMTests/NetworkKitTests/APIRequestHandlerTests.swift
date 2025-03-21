import XCTest
@testable import DemoSwiftMVVM

final class APIRequestHandlerTests: XCTestCase {
    var requestHandler: RequestHandler!
    var request: MockDogsListRequest!
    
    override func setUpWithError() throws {
        requestHandler = APIRequestHandler(session: URLSession.mock)
        request = MockDogsListRequest()
    }

    override func tearDownWithError() throws {
        requestHandler = nil
        request = nil
    }

    func testAPIRequestHandlerReturnsData() async throws {
        MockURLProtocol.requestHandler = { request in
            guard request.url == self.request.url else {
                throw RequestError.invalidURL
            }
            
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (MockResponse.postData, response)
        }
        
        let result = try await requestHandler!.sendRequest(request)
        let resultData = try XCTUnwrap(result)
        
        // verify data exists
        XCTAssertTrue(!resultData.isEmpty)
        
        // verify data correctness
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: result) as? [String: Any])
        
        let message = try XCTUnwrap(json["message"] as? [String])
        XCTAssertGreaterThan(message.count, 0)
        
        let status = try XCTUnwrap(json["status"] as? String)
        XCTAssertEqual(status, "success")
    }
    
    func testAPIRequestHandlerThrowsUnAuthorizedError() async throws {
        MockURLProtocol.requestHandler = { request in
            guard request.url == self.request.url else {
                throw RequestError.invalidURL
            }
            let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
            return (Data(), response)
        }
        
        let expectation = XCTestExpectation(description: "APIRequestHandler throws UnAuthorized error")
        do {
            let _ = try await requestHandler!.sendRequest(request)
            XCTFail("APIRequestHandler should throw unAuthorized error")
        } catch RequestError.unauthorized {
            expectation.fulfill()
        }
    }
    
    func testAPIRequestHandlerThrowsUnExpectedError() async throws {
        MockURLProtocol.requestHandler = { request in
            guard request.url == self.request.url else {
                throw RequestError.invalidURL
            }
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (Data(), response)
        }
        
        let expectation = XCTestExpectation(description: "APIRequestHandler throws Unexpected error")
        do {
            let _ = try await requestHandler!.sendRequest(request)
            XCTFail("APIRequestHandler should throw unexpectedStatusCode error")
        } catch RequestError.unexpectedStatusCode {
            expectation.fulfill()
        }
    }
}
