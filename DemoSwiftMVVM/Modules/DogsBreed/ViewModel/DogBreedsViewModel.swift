import Foundation
import Combine

// MARK: - DogBreedsViewModel

final class DogBreedsViewModel {
    private let dogsBreedListService: DogsBreedListService
    
    init(dogsBreedListService: DogsBreedListService = DogsBreedService()) {
        self.dogsBreedListService = dogsBreedListService
    }
    
    // MARK: - Properties
    @Published var dogsBreedList: [String] = []
    
    func loadDogsBreedData() async throws {
        if !Reachability.shared.isConnectedToNetwork() {
            debugPrint("Network not Reachable")
            return
        }
        let dogsBreed = try await dogsBreedListService.getDogsBreedList()
        await MainActor.run {
            self.dogsBreedList = dogsBreed.message
        }
    }
    
    func dogsBreed(atIndexPath indexPath: IndexPath) -> String {
        dogsBreedList[indexPath.row]
    }
}
