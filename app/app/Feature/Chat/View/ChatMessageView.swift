import SwiftUI
import Kingfisher

struct ChatMessageView: View {

    let chatRoomId: Int64
    let memberId: Int64
    let nickname: String
    let thumbnail: String?

    @StateObject private var vm: ChatMessageViewModel
    @StateObject private var stomp = StompManager.shared

    @Namespace var namespace

    @State private var message: String = ""

    init(chatRoomId: Int64, memberId: Int64, nickname: String, thumbnail: String?) {
        self.chatRoomId = chatRoomId
        self.memberId = memberId
        self.nickname = nickname
        self.thumbnail = thumbnail

        _vm = StateObject(wrappedValue: ChatMessageViewModel(chatRoomId: chatRoomId))
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(vm.chatMessages) { it in
                        ChatMessageRowView(
                            memberId: AuthStore.shared.memberId ?? 0,
                            targetId: it.senderId,
                            content: it.content,
                            createdAt: it.createdAt
                        )
                        .rotationEffect(.degrees(180))
                        .onAppear {
                            if it.id == vm.chatMessages.last?.id {
                                Task {
                                    await vm.loadMoreChatMessages(chatRoomId: chatRoomId)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .safeAreaInset(edge: .top) {
                chatMessageInput
            }
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                Task {
                    await vm.markAsRead(chatRoomId: chatRoomId)
                }
                stomp.subscribe(to: "/sub/chat-rooms/\(chatRoomId)")
            }
            .onDisappear {
                Task {
                    await vm.markAsRead(chatRoomId: chatRoomId)
                }
                stomp.unsubscribe(from: "/sub/chat-rooms/\(chatRoomId)")
            }
            .task {
                await vm.fetchChatMessages(chatRoomId: chatRoomId)
            }
            .rotationEffect(.degrees(180))
            .navigationTitle(nickname)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ProfileView(memberId: memberId)
                    } label: {
                        KFImage(URL(string: thumbnail ?? ""))
                            .resizable()
                            .placeholder {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 27, height: 27)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                                    .clipShape(Circle())
                            }
                            .font(.title)
                            .frame(width: 27, height: 27)
                            .foregroundColor(Color(.systemGray6))
                            .background(Color(.systemGray4))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }

    // MARK: - Subview

    private var chatMessageInput: some View {
        GlassEffectContainer(spacing: 5) {
            HStack(alignment: .bottom) {
                Image(systemName: "paperclip")
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .foregroundColor(.primary)
                    .clipShape(Circle())
                    .glassEffect(.regular.tint(Color(.clear)).interactive())

                TextField("메시지 입력", text: $message, axis: .vertical)
                    .font(.system(size: 16))
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .lineLimit(5)
                    .padding(.leading)
                    .padding(.trailing, 50)
                    .padding(.vertical, 8)
                    .frame(minHeight: 44)
                    .overlay(
                        HStack {
                            Spacer()
                            Button {
                                guard !message.trimmingCharacters(in: .whitespaces).isEmpty else { return }

                                if vm.sendChatMessage(chatRoomId: chatRoomId, content: message, type: "TEXT") == true {
                                    message = ""
                                }
                            } label: {
                                Image(systemName: "paperplane.fill")
                                    .foregroundColor(.white)
                                    .frame(width: 36, height: 36)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                            .padding(.trailing, 4)
                            .padding(.bottom, 4)
                        }, alignment: .bottom
                    )
                    .glassEffect(
                        .regular.tint(.clear).interactive(),
                        in: .rect(cornerRadius: 20)
                    )
            }
        }
        .rotationEffect(.degrees(180))
        .padding()
    }
}
