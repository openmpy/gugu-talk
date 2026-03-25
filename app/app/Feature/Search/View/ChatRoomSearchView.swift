import SwiftUI

struct ChatRoomSearchView: View {

    @StateObject private var vm = ChatRoomSearchViewModel()

    @State private var searchNickname: String = ""

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
                                        await vm.loadMoreChatRooms(nickname: searchNickname)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $searchNickname,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "닉네임 입력"
            )
            .onSubmit(of: .search) {
                Task {
                    await vm.fetchChatRooms(nickname: searchNickname)
                }
            }
            .task {
                if !searchNickname.isEmpty {
                    await vm.fetchChatRooms(nickname: searchNickname)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("채팅방 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
