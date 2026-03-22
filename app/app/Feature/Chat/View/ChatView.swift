import SwiftUI

struct ChatView: View {

    @State private var selectStatus: String = "전체"

    var body: some View {
        NavigationStack {
            Picker("전체", selection: $selectStatus) {
                Text("전체").tag("전체")
                Text("안읽음").tag("안읽음")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<1000) { i in
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .font(.title)
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color(.systemGray6))
                                .background(Color(.systemGray4))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 5) {
                                HStack {
                                    Text("닉네임")
                                        .font(.headline.bold())

                                    Spacer()

                                    Text("방금 전")
                                        .font(.caption)
                                        .foregroundColor(Color(.systemGray))
                                }

                                HStack(alignment: .center) {
                                    Text(i % 2 == 0
                                         ? "메시지메시지메시지메시지메시지메시지메시"
                                         : "메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시지메시"
                                    )
                                    .lineLimit(2)
                                    .font(.subheadline)
                                    .foregroundColor(Color(.systemGray))

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
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // 검색
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 채팅 수신
                    } label: {
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView()
}
