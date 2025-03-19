import UIKit
import Combine

class DogBreedsViewController: UIViewController, CoordinatorBoard {
    
    private(set) var viewModel = DogBreedsViewModel(dogsBreedListService: DogsBreedService())
    
    // MARK: - Properties
    var coordinator: AppCoordinator?
    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private var cellIdentifier = "DogsBreddListTableViewCell"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        getDogsBreed()
    }
    
    func getDogsBreed() {
        Task {
            try await viewModel.loadDogsBreedData()
        }
    }
}

// MARK: - Observables

extension DogBreedsViewController {
    
    func setupObservers() {
        ApplicationLoader.shared.startLoading(view: self.view)
        viewModel.$dogsBreedList
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                ApplicationLoader.shared.stopLoading()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension DogBreedsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dogsBreedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(withIdentifier: cellIdentifier, style: .subtitle)
        let dogsbreedName = viewModel.dogsBreed(atIndexPath: indexPath)
        cell.textLabel?.text = dogsbreedName.capitalized
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DogBreedsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dogsbreedName = viewModel.dogsBreed(atIndexPath: indexPath)
        coordinator?.showDogsImagesViewController(breedName: dogsbreedName)
    }
}

// MARK: - UISetup

extension DogBreedsViewController {
    
    func setupViews() {
        self.title = "DogsBreed"
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperViewEdges()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
}
