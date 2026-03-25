import SwiftUI
import Combine

@MainActor
final class ChatRoomViewModel: ObservableObject {

    private let service = ChatRoomService.shared
    private let stomp = StompManager.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var chatRooms: [ChatRoomGetResponse] = []

    private var cancellables = Set<AnyCancellable>()
    private var cursorId: Int64?
    private var cursorDateAt: String?

    init() {
        stomp.chatRoomDeleteSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] chatRoomId in
                self?.chatRooms.removeAll { $0.chatRoomId == chatRoomId }
            }
            .store(in: &cancellables)

        stomp.chatRoomUpdateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }

                if let idx = chatRooms.firstIndex(where: { $0.chatRoomId == event.chatRoomId }) {
                    var updated = chatRooms.remove(at: idx)

                    updated.lastMessage = event.lastMessage ?? ""
                    updated.lastMessageAt = event.lastMessageAt ?? ""
                    updated.unreadCount = updated.unreadCount + 1
                    chatRooms.insert(updated, at: 0)
                } else {
                    let newRoom = ChatRoomGetResponse(
                        chatRoomId: event.chatRoomId,
                        memberId: event.memberId ?? 0,
                        thumbnail: event.thumbnail ?? "",
                        nickname: event.nickname ?? "",
                        lastMessage: event.lastMessage ?? "",
                        lastMessageAt: event.lastMessageAt ?? "",
                        unreadCount: event.unreadCount ?? 0
                    )
                    chatRooms.insert(newRoom, at: 0)
                }
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: .chatRoomMarkAsRead)
            .receive(on: DispatchQueue.main)
            .compactMap { $0.object as? Int64 }
            .sink { [weak self] chatRoomId in
                guard let self else { return }
                if let idx = chatRooms.firstIndex(where: { $0.chatRoomId == chatRoomId }) {
                    chatRooms[idx].unreadCount = 0
                }
            }
            .store(in: &cancellables)
    }

    func fetchChatRooms() async {
        hasNext = true

        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.gets(
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

    func loadMoreChatRooms() async {
        guard !isLoading, hasNext else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.gets(
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

    func deleteChatRoom(chatRoomId: Int64) async -> Bool {
        guard !isLoading else {
            return false
        }
        
        isLoading = true
        defer { isLoading = false }

        do {
            try await service.delete(chatRoomId: chatRoomId)
            chatRooms.removeAll { $0.id == chatRoomId }
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }
}
