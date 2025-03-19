import Foundation

enum DogsImageRequest: Request {
    case imageByDogsBreed(breed: String)
    
    var path: String {
        switch self {
        case .imageByDogsBreed(let breed):
            return "/api/breed/\(breed)/images/random/10"
        }
    }
}

protocol DogsImageRetrievalService {
    func getDogsImage(breedName: String) async throws -> DogsImage
}

// MARK: - PhotoService

class DogsImageService: DogsImageRetrievalService {
    let networkManager: NetworkHandler
    
    init(networkManager: NetworkHandler = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getDogsImage(breedName: String) async throws -> DogsImage {
        try await networkManager.fetch(request: DogsImageRequest.imageByDogsBreed(breed: breedName))
    }
}
