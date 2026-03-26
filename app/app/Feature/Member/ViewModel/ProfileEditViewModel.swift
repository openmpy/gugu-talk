import SwiftUI
import PhotosUI
import Combine

@MainActor
final class ProfileEditViewModel: ObservableObject {

    private let imageService = ImageService.shared
    private let memberQueryService = MemberQueryService.shared
    private let memberImageService = MemberImageService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    @Published var member: MemberGetMyResponse = MemberGetMyResponse(
        memberId: 0,
        publicImages: [],
        privateImages: [],
        nickname: "",
        birthYear: 0,
        bio: nil
    )

    func getMy() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await memberQueryService.getMy()
            member = response
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func uploadImages(
        publicImages: [EditableImage],
        privateImages: [EditableImage],
        originalPublicIds: [Int64],
        originalPrivateIds: [Int64]
    ) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            try await uploadGroup(images: publicImages, type: "PUBLIC", originalIds: originalPublicIds)
            try await uploadGroup(images: privateImages, type: "PRIVATE", originalIds: originalPrivateIds)
            return true
        } catch {
            ToastManager.shared.show("이미지 업로드에 실패했습니다.", type: .error)
            return false
        }
    }

    private func uploadGroup(images: [EditableImage], type: String, originalIds: [Int64]) async throws {
        // 현재 남아있는 서버 이미지 ID
        let currentServerIds = Set(images.compactMap { $0.serverInfo?.imageId })
        // 삭제된 서버 이미지 ID
        let deleteIds = originalIds.filter { !currentServerIds.contains($0) }

        var imageItems: [ImageItemRequest] = []

        for (index, editableImage) in images.enumerated() {
            if let serverInfo = editableImage.serverInfo {
                // 기존 서버 이미지
                imageItems.append(ImageItemRequest(
                    id: serverInfo.imageId,
                    key: nil,
                    type: type,
                    sortOrder: index
                ))
            } else {
                // 새 이미지
                let resized = resizeIfNeeded(editableImage.uiImage)
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
        }

        guard !imageItems.isEmpty || !deleteIds.isEmpty else { return }

        let saveRequest = MemberImageSaveRequest(images: imageItems, deleteIds: deleteIds)
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
