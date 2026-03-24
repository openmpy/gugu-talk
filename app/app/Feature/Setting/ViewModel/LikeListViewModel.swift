import SwiftUI
import Combine

@MainActor
final class LikeListViewModel: ObservableObject {

    private let service = MemberLikeService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var likes: [MemberSettingResponse] = []

    private var cursorId: Int64?

    func fetchLikes() async {
        hasNext = true

        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.gets(
                cursorId: nil,
                limit: 20
            )

            likes = response.payload
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func loadMoreLikes() async {
        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.gets(
                cursorId: cursorId,
                limit: 20
            )

            likes.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func unlike(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let _ = try await service.cancel(targetId: targetId)
            likes.removeAll(where: { $0.memberId == targetId })
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
