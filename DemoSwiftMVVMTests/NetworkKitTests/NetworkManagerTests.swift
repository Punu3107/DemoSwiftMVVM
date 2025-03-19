//
//  NetworkManagerTests.swift
//  MVVMDemoTests
//
//  Created by Rushi Sangani on 30/11/2023.
//

import XCTest
import Combine
@testable import DemoSwiftMVVM

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkHandler!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }
    
    func testNetworkManagerGetData() async throws {
        networkManager = NetworkManager(
            requestHandler: MockAPIRequestHandler(shouldSucceed: true),
            responseHandler: MockAPIResponseHandler(shouldSucceed: true)
        )
        
        var result: DogBreedsModel!
        let request = MockDogsListRequest()
        
        let expectation = XCTestExpectation(description: "NetworkManager Get Data")
        do {
            result  = try await networkManager.fetch(request: request)
            expectation.fulfill()

            // verify data correctness
            let message = try XCTUnwrap(result.message.first)
            XCTAssert(message == "affenpinscher")
            XCTAssert(result.status == "success")
        } catch {
            print(error)
            XCTFail("Expected NetworkManager should complete fetch request.")
        }
    }
    
    func testNetworkManagerThrowsError() async throws {
        networkManager = NetworkManager(
            requestHandler: MockAPIRequestHandler(shouldSucceed: false),
            responseHandler: MockAPIResponseHandler(shouldSucceed: false)
        )
        
        let request = MockDogsListRequest()
        
        let expectation = XCTestExpectation(description: "NetworkManager throws error")
        do {
            let _: [DogBreedsModel] = try await networkManager!.fetch(request: request)
            XCTFail("Expected NetworkManager should throw error while getting comments")
        } catch RequestError.noData {
            expectation.fulfill()
        }
    }
}

// MARK: - Mocks

fileprivate class MockAPIRequestHandler: RequestHandler {
    
    private let shouldSucceed: Bool
    // Important to get bundle as below
    private var bundle: Bundle {
        Bundle.main
    }
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func sendRequest(_ request: Request) async throws -> Data {
        if shouldSucceed {
            return try bundle.fileData(forResource: "breed")
        }
        throw RequestError.noData
    }
    
    func sendRequest(_ request: Request) -> AnyPublisher<Data, RequestError> {
        if shouldSucceed {
            guard let data = try? bundle.fileData(forResource: "breed") else { return Fail(error: RequestError.noData).eraseToAnyPublisher() }
            return Just(data)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
            
        }
        return Fail(error: RequestError.noData)
            .eraseToAnyPublisher()
    }
}

private class MockAPIResponseHandler: ResponseHandler {
    private let shouldSucceed: Bool
    
    init(shouldSucceed: Bool) {
        self.shouldSucceed = shouldSucceed
    }
    
    func getResponse<T>(from response: Data) throws -> T where T : Decodable {
        if shouldSucceed {
            try JSONDecoder().decode(T.self, from: response)
        } else {
            throw RequestError.decode(description: "No data")
        }
    }
}
