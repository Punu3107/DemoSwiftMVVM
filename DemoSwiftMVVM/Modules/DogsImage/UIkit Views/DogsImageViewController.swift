import UIKit
import Combine
import SDWebImage

class DogsImageViewController: UIViewController, CoordinatorBoard {
    
    private(set) var viewModel: DogsImageViewModel
    private(set) var breedName: String
    
    init(viewModel: DogsImageViewModel, breedName: String) {
        self.viewModel = viewModel
        self.breedName = breedName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    weak var coordinator: DogsImageCoordinator?
    private(set) var tableView = UITableView(frame: .zero, style: .plain)
    private var cellIdentifier = "DogsImageTableViewCell"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        getDogsImages()
    }
    
    func getDogsImages() {
        if !Reachability.shared.isConnectedToNetwork() {
            debugPrint("Network not Reachable")
            return
        }
        Task {
            try await viewModel.getDogImages(breedName: self.breedName)
        }
    }
}

// MARK: - Observables

extension DogsImageViewController {
    
    func setupObservers() {
        ApplicationLoader.shared.startLoading(view: self.view)
        viewModel.$images
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                ApplicationLoader.shared.stopLoading()
            }
            .store(in: &cancellables)
    }
}

extension DogsImageViewController {
    
    func showImage(_ image: UIImage, atIndexPath indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - UITableViewDataSource

extension DogsImageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DogsImageTableViewCell else {return UITableViewCell()}
        cell.title.text = "\(indexPath.row+1).\(self.breedName.capitalized)"
        if let url = URL(string: viewModel.imageUrl(at: indexPath)) {
            cell.photoImageView.sd_setImage(with: url)
        }
        return cell
    }
}

// MARK: - UISetup

extension DogsImageViewController {
    
    func setupViews() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperViewEdges()
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        navigationItem.title = "Dogs Images"
        tableView.dataSource = self
        // tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
    }
}
