import Foundation
import UIKit

final class DogsImageViewModel {
    
    // MARK: - Properties
    
    @Published var images: [String] = []
    private let service: DogsImageRetrievalService
    
    init(service: DogsImageRetrievalService = DogsImageService()) {
        self.service = service
    }
    
    func getDogImages(breedName: String) async throws {
        let images = try await service.getDogsImage(breedName: breedName)
        await MainActor.run {
            self.images = images.message
        }
    }
    
    func imageUrl(at indexPath: IndexPath) -> String {
        images[indexPath.row]
    }
}
