import Foundation
import Alamofire

final class ImageService {
    
    static let shared = ImageService()
    
    func uploadToS3(presignedUrl: String, imageData: Data) async throws {
        try await AF.request(
            presignedUrl,
            method: .put,
            headers: ["Content-Type": "image/jpeg"],
            requestModifier: { $0.httpBody = imageData }
        )
        .validateWithErrorHandling()
    }
}
