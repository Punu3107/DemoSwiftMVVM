import UIKit

class DogsImageCoordinator: Coordinator {
    func configureRootViewcontroller() {
        let viewController = DogsImageViewController(viewModel: DogsImageViewModel(), breedName: self.breedName)
        viewController.coordinator = self
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    weak var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var breedName: String = ""
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
