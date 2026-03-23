import SwiftUI
import Combine

@MainActor
final class MemberSearchViewModel: ObservableObject {

    private let service = MemberSearchService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var members: [MemberSearchNicknameResponse] = []

    private var cursorId: Int64?

    func fetchMembers(nickname: String) async {
        hasNext = true

        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.searchMembers(
                nickname: nickname,
                cursorId: nil,
                limit: 20
            )

            members = response.payload
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func loadMoreMembers(nickname: String) async {
        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.searchMembers(
                nickname: nickname,
                cursorId: cursorId,
                limit: 20
            )

            members.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
