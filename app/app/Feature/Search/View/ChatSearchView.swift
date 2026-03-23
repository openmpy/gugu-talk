import SwiftUI

struct ChatSearchView: View {

    @State private var searchNickname: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<1000) { i in
                        NavigationLink {
                            ChatRoomView()
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
                                        Text("닉네임")
                                            .font(.headline.bold())
                                            .foregroundColor(.primary)

                                        Spacer()

                                        Text("방금 전")
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }

                                    HStack(alignment: .center) {
                                        Text(i % 2 == 0
                                             ? "메시지메시지메시지메시지메시지메시지메시메시"
                                             : "메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시"
                                        )
                                        .lineLimit(2)
                                        .font(.subheadline)
                                        .foregroundColor(Color(.systemGray))
                                        .multilineTextAlignment(.leading)

                                        Spacer()

                                        Text("99")
                                            .font(.caption2)
                                            .foregroundColor(Color(.systemBackground))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color(.systemGray2))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .searchable(
                text: $searchNickname,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "닉네임 입력"
            )
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("채팅 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    MemberSearchView()
}
