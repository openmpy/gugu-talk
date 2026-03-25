import SwiftUI

struct ChatRoomView: View {

    @StateObject private var vm = ChatRoomViewModel()
    @StateObject private var stomp = StompManager.shared

    @State private var selectStatus: String = "ALL"

    var body: some View {
        NavigationStack {
            Picker("상태", selection: $selectStatus) {
                Text("전체").tag("ALL")
                Text("안읽음").tag("UNREAD")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(vm.chatRooms) { it in
                        NavigationLink {
                            ChatMessageView(
                                chatRoomId: it.chatRoomId,
                                memberId: it.memberId,
                                nickname: it.nickname,
                                thumbnail: it.thumbnail
                            )
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text(it.nickname)
                                            .font(.headline.bold())
                                            .foregroundColor(.primary)

                                        Spacer()

                                        Text(it.lastMessageAt.customFormattedTime)
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }

                                    HStack(alignment: .center) {
                                        Text(it.lastMessage.byCharWrapping)
                                            .lineLimit(2)
                                            .font(.subheadline)
                                            .foregroundColor(Color(.systemGray))
                                            .multilineTextAlignment(.leading)

                                        Spacer()

                                        if it.unreadCount > 0 {
                                            Text(it.unreadCount > 99 ? "99+" : "\(it.unreadCount)")
                                                .font(.caption2)
                                                .foregroundColor(Color(.systemBackground))
                                                .padding(.horizontal, 6)
                                                .padding(.vertical, 2)
                                                .background(Color(.systemGray2))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
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
}
