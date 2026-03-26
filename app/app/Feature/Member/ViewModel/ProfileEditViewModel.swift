import SwiftUI
import PhotosUI
import Combine

@MainActor
final class ProfileEditViewModel: ObservableObject {

    private let imageService = ImageService.shared
    private let memberImageService = MemberImageService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func uploadImages(publicImages: [UIImage], privateImages: [UIImage]) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            try await uploadGroup(images: publicImages, type: "PUBLIC")
            try await uploadGroup(images: privateImages, type: "PRIVATE")
            return true
        } catch {
            ToastManager.shared.show("이미지 업로드에 실패했습니다.", type: .error)
            return false
        }
    }

    private func uploadGroup(images: [UIImage], type: String) async throws {
        guard !images.isEmpty else { return }

        var imageItems: [ImageItemRequest] = []

        for (index, image) in images.enumerated() {
            let resized = resizeIfNeeded(image)
            guard let data = resized.jpegData(compressionQuality: 0.8) else { continue }

            let presigned = try await memberImageService.getPresignedUrl(type: type)
            try await imageService.uploadToS3(presignedUrl: presigned.url, imageData: data)

            imageItems.append(ImageItemRequest(
                id: nil,
                key: presigned.key,
                type: type,
                sortOrder: index
            ))
        }

        let saveRequest = MemberImageSaveRequest(images: imageItems, deleteIds: [])
        try await memberImageService.saveImages(request: saveRequest)
    }

    private func resizeIfNeeded(_ image: UIImage, maxDimension: CGFloat = 1080) -> UIImage {
        let width = image.size.width
        let height = image.size.height

        guard width > maxDimension || height > maxDimension else { return image }

        let scale = maxDimension / max(width, height)
        let newSize = CGSize(width: width * scale, height: height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
