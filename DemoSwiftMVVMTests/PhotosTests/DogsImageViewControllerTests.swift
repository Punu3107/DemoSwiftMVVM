import XCTest
@testable import DemoSwiftMVVM

final class DogsImageViewControllerTests: XCTestCase {
    var dogsListVC: DogsImageViewController!
    var viewModel: DogsImageViewModel!
    var breedName: String!
    
    override func setUpWithError() throws {
        breedName = "african"
        viewModel = DogsImageViewModel(service: MockDogsImageRetrievalService())
        dogsListVC = DogsImageViewController(viewModel: viewModel, breedName: breedName)
    }

    override func tearDownWithError() throws {
        dogsListVC = nil
        viewModel = nil
    }

    func test_dogsImageVC_showDogsImageInTableView() throws {
        let expectation = XCTestExpectation(description: "TableView has data")
        
        dogsListVC.loadView()
        dogsListVC.setupObservers()
        
        Task {
            do {
                try await viewModel.getDogImages(breedName: breedName)
                expectation.fulfill()
            } catch {
                XCTFail("Expected viewmodel should load posts")
            }
        }
        
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(viewModel.images.count, dogsListVC.tableView.numberOfRows(inSection: 0))
    }

}
