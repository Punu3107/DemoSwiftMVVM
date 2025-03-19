import XCTest
@testable import DemoSwiftMVVM

final class DogBreedsViewControllerTests: XCTestCase {
    var dogsListVC: DogBreedsViewController!
    var viewModel: DogBreedsViewModel!
    
    override func setUpWithError() throws {
        viewModel = DogBreedsViewModel(dogsBreedListService: MockDogsBreedListService())
        dogsListVC = DogBreedsViewController()
    }

    override func tearDownWithError() throws {
        dogsListVC = nil
        viewModel = nil
    }

    func testDogsListVCShowDogsBreedListInTableView() throws {
        let expectation = XCTestExpectation(description: "TableView has data")
        
        dogsListVC.loadView()
        dogsListVC.setupObservers()
        
        Task {
            do {
                try await viewModel.loadDogsBreedData()
                expectation.fulfill()
            } catch {
                XCTFail("Expected viewmodel should load list")
            }
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertNotEqual(viewModel.dogsBreedList.count, dogsListVC.tableView.numberOfRows(inSection: 0))
    }

}
