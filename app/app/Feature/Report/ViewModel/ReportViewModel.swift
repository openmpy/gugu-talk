import SwiftUI
import Combine

@MainActor
final class ReportViewModel: ObservableObject {

    private let reportService = ReportService.shared
    private let reportImageService = ReportImageService.shared
    private let imageService = ImageService.shared

    @Published var isLoading: Bool = false
    @Published var isSubmitted: Bool = false

    func submit(
        reportedId: Int64,
        type: ReportType,
        images: [UIImage],
        reason: String
    ) async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            var imageItems: [ReportImageItemRequest] = []

            for image in images {
                let resized = resizeIfNeeded(image)
                guard let data = resized.jpegData(compressionQuality: 0.8) else { continue }

                let presigned = try await reportImageService.getPresignedUrl(reportedId: reportedId)
                try await imageService.uploadToS3(presignedUrl: presigned.url, imageData: data)

                imageItems.append(ReportImageItemRequest(key: presigned.key))
            }

            let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
            let request = ReportSaveRequest(
                type: type.rawValue,
                images: imageItems,
                reason: trimmedReason.isEmpty ? nil : trimmedReason
            )

            try await reportService.save(reportedId: reportedId, request: request)

            isSubmitted = true
            ToastManager.shared.show("신고가 접수되었습니다.")
        } catch {
            ToastManager.shared.show("신고 접수에 실패했습니다.", type: .error)
        }
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
