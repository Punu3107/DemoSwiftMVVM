import Foundation

// MARK: - DogsBreedListRequest

enum DogsBreedRequest: Request {
    case getDogsBreedList
    
    var path: String {
        switch self {
        case .getDogsBreedList:
            return "/api/breeds/list"
        }
    }
}

protocol DogsBreedListService {
    func getDogsBreedList() async throws -> DogBreeds
}

// MARK: - DogsBreedService

class DogsBreedService: DogsBreedListService {
    let networkManager: NetworkHandler
    
    init(networkManager: NetworkHandler = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getDogsBreedList() async throws -> DogBreeds {
        try await networkManager.fetch(request: DogsBreedRequest.getDogsBreedList)
    }
}
