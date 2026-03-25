import SwiftUI
import Combine

@MainActor
final class ChatMessageViewModel: ObservableObject {

    private let service = ChatRoomService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var chatMessages: [ChatMessageGetResponse] = []

    private var cursorId: Int64?

    func fetchChatMessages(chatRoomId: Int64) async {
        hasNext = true

        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.get(
                chatRoomId: chatRoomId,
                cursorId: nil,
                limit: 20
            )

            chatMessages = response.payload
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func loadMoreChatMessages(chatRoomId: Int64) async {
        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.get(
                chatRoomId: chatRoomId,
                cursorId: cursorId,
                limit: 20
            )

            chatMessages.append(contentsOf: response.payload)
            cursorId = response.nextId
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
