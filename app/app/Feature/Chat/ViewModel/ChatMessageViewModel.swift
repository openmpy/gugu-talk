import SwiftUI
import Combine

@MainActor
final class ChatMessageViewModel: ObservableObject {

    private let service = ChatRoomService.shared
    private let stomp = StompManager.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var chatMessages: [ChatMessageGetResponse] = []

    private var cancellables = Set<AnyCancellable>()
    private var cursorId: Int64?

    init(chatRoomId: Int64) {
        stomp.chatMessageSubject
            .filter { $0.chatRoomId == chatRoomId }
            .map { try? JSONDecoder().decode(ChatMessageGetResponse.self, from: $0.data) }
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }

                self.chatMessages.insert(message, at: 0)
            }
            .store(in: &cancellables)

        stomp.chatMessageSubject
            .filter { $0.chatRoomId == chatRoomId }
            .debounce(for: .seconds(0.5) , scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }

                Task {
                    await self.markAsRead(chatRoomId: chatRoomId)
                }
            }
            .store(in: &cancellables)
    }

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

    func sendChatMessage(chatRoomId: Int64, content: String, type: String) -> Bool {
        guard let data = try? JSONEncoder().encode(
            ChatMessageSendRequest(
                content: content,
                type: type
            )
        ), let body = String(data: data, encoding: .utf8) else { return false }

        stomp.send(
            body: body,
            to: "/pub/chat-rooms/\(chatRoomId)/message",
            headers: ["content-type": "application/json"]
        )
        return true
    }

    func markAsRead(chatRoomId: Int64) async {
        do {
            try await service.markAsRead(chatRoomId: chatRoomId)
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
