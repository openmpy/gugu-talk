import SwiftUI
import Combine

@MainActor
final class ChatRoomSearchViewModel: ObservableObject {

    private let service = ChatRoomService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var chatRooms: [ChatRoomGetResponse] = []

    private var cancellables = Set<AnyCancellable>()
    private var cursorId: Int64?
    private var cursorDateAt: String?

    func fetchChatRooms(nickname: String) async {
        hasNext = true

        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.search(
                keyword: nickname,
                cursorId: nil,
                cursorDateAt: nil,
                limit: 20
            )

            chatRooms = response.payload
            cursorId = response.nextId
            cursorDateAt = response.nextDateAt
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func loadMoreChatRooms(nickname: String) async {
        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.search(
                keyword: nickname,
                cursorId: cursorId,
                cursorDateAt: cursorDateAt,
                limit: 20
            )

            chatRooms.append(contentsOf: response.payload)
            cursorId = response.nextId
            cursorDateAt = response.nextDateAt
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
