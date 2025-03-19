import Foundation
import UIKit
import SwiftUI

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func configureRootViewcontroller()
}

class AppCoordinator: Coordinator {
    
     var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func configureRootViewcontroller() {
        guard let dogsBreedVc = DogBreedsViewController.instansiateFromStoryBoard() else {return}
        dogsBreedVc.coordinator = self
        self.navigationController.pushViewController(dogsBreedVc , animated: false)
    }
    
    func showDogsImagesViewController(breedName:String) {
        let child = DogsImageCoordinator(navigationController: navigationController)
        child.breedName = breedName
        child.configureRootViewcontroller()
    }
}
