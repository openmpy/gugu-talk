import SwiftUI

struct ChatRoomSearchView: View {

    @StateObject private var vm = ChatRoomSearchViewModel()

    @State private var keyword: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    if vm.chatRooms.isEmpty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    } else {
                        ForEach(vm.chatRooms) { it in
                            NavigationLink {
                                ChatMessageView(
                                    chatRoomId: it.chatRoomId,
                                    memberId: it.memberId,
                                    nickname: it.nickname,
                                    thumbnail: it.thumbnail
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
                                        await vm.loadMoreChatRooms(nickname: keyword)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $keyword,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "닉네임 입력"
            )
            .onSubmit(of: .search) {
                Task {
                    await vm.fetchChatRooms(nickname: keyword)
                }
            }
            .task {
                if !keyword.isEmpty {
                    await vm.fetchChatRooms(nickname: keyword)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("채팅방 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
