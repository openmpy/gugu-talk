import SwiftUI
import Combine

@MainActor
final class ChatRoomViewModel: ObservableObject {

    private let service = ChatRoomService.shared
    private let memberQueryService = MemberQueryService.shared
    private let memberCommandService = MemberCommandService.shared
    private let stomp = StompManager.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true

    @Published var chatRooms: [ChatRoomGetResponse] = []
    @Published var isChatEnabled: Bool = true

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

    func fetchChatRooms(status: String) async {
        hasNext = true
        guard !isLoading, hasNext else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await status == "ALL"
                ? service.gets(cursorId: nil, cursorDateAt: nil, limit: 20)
                : service.getsUnread(cursorId: nil, cursorDateAt: nil, limit: 20)

            chatRooms = response.payload
            cursorId = response.nextId
            cursorDateAt = response.nextDateAt
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func loadMoreChatRooms(status: String) async {
        guard !isLoading, hasNext else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await status == "ALL"
                ? service.gets(cursorId: cursorId, cursorDateAt: cursorDateAt, limit: 20)
                : service.getsUnread(cursorId: cursorId, cursorDateAt: cursorDateAt, limit: 20)
            
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

    func markAsRead(chatRoomId: Int64) async -> Bool {
        guard !isLoading else {
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await service.markAsRead(chatRoomId: chatRoomId)

            if let index = chatRooms.firstIndex(where: { $0.chatRoomId == chatRoomId }) {
                chatRooms[index].unreadCount = 0
            }
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }

    func getChatEnabled() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await memberQueryService.getChatEnabled(memberId: AuthStore.shared.memberId ?? 0)
            isChatEnabled = response.isChatEnabled
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func toggleChatEnabled() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await memberCommandService.toogleChatEnabled(memberId: AuthStore.shared.memberId ?? 0)

            isChatEnabled = response.isChatEnabled
            ToastManager.shared.show(isChatEnabled ? "이제 쪽지를 받을 수 있습니다." : "더 이상 쪽지를 받지 않습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
