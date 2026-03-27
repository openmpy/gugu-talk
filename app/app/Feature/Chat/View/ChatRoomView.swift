import SwiftUI

struct ChatRoomView: View {

    @StateObject private var vm = ChatRoomViewModel()
    @StateObject private var stomp = StompManager.shared

    @State private var selectStatus: String = "ALL"

    var body: some View {
        NavigationStack {
            VStack {
                ChatRoomStatusPickerView(selectStatus: $selectStatus)

                if vm.chatRooms.isEmpty {
                    Spacer()

                    Text("내역이 없습니다")
                        .foregroundColor(.secondary)
                        .padding(.vertical)

                    Spacer()
                } else {
                    chatRoomList
                }
            }
            .onAppear {
                stomp.subscribe(to: "/sub/chat-rooms/members/\(AuthStore.shared.memberId ?? 0)")
            }
            .onDisappear {
                stomp.unsubscribe(from: "/sub/chat-rooms/members/\(AuthStore.shared.memberId ?? 0)")
            }
            .onChange(of: selectStatus) { _, newValue in
                Task {
                    await vm.fetchChatRooms(status: newValue)
                }
            }
            .task {
                await vm.fetchChatRooms(status: selectStatus)
                await vm.getChatEnabled()
            }
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        ChatRoomSearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await vm.toggleChatEnabled()
                        }
                    } label: {
                        Image(systemName: vm.isChatEnabled ? "bell" : "bell.slash")
                    }
                }
            }
        }
    }

    // MARK: - Subview

    private var chatRoomList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(vm.chatRooms) { it in
                    NavigationLink {
                        ChatMessageView(
                            chatRoomId: it.chatRoomId,
                            memberId: it.memberId
                        )
                    } label: {
                        ChatRoomRowView(
                            thumbnail: it.thumbnail,
                            nickname: it.nickname,
                            lastMessageAt: it.lastMessageAt,
                            lastMessage: it.lastMessage,
                            unreadCount: it.unreadCount
                        )
                    }
                    .onAppear {
                        if it.id == vm.chatRooms.last?.id {
                            Task {
                                await vm.loadMoreChatRooms(status: selectStatus)
                            }
                        }
                    }
                    .contextMenu {
                        Button(role: .confirm) {
                            Task {
                                if await vm.markAsRead(chatRoomId: it.chatRoomId) {
                                    ToastManager.shared.show("읽음 처리 되었습니다.")
                                }
                            }
                        } label: {
                            Label("읽음", systemImage: "eye")
                        }
                        Button(role: .destructive) {
                            Task {
                                if await vm.deleteChatRoom(chatRoomId: it.chatRoomId) {
                                    ToastManager.shared.show("채팅방을 삭제하셨습니다.")
                                }
                            }
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
                }
            }
        }
    }
}
