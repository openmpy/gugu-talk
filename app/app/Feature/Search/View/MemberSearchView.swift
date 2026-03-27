import SwiftUI

struct MemberSearchView: View {

    @StateObject private var vm = MemberSearchViewModel()

    @State private var keyword: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    if vm.members.isEmpty {
                        Text("검색 결과가 없습니다")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    } else {
                        ForEach(vm.members) { it in
                            NavigationLink {
                                ProfileView(memberId: it.memberId)
                            } label: {
                                MemberSearchRowView(
                                    thumbnail: it.thumbnail,
                                    nickname: it.nickname,
                                    gender: it.gender,
                                    updatedAt: it.updatedAt,
                                    age: it.age,
                                    likes: it.likes
                                )
                            }
                            .onAppear {
                                if it.id == vm.members.last?.id {
                                    Task {
                                        await vm.loadMoreMembers(nickname: keyword)
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
                    await vm.fetchMembers(nickname: keyword)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("회원 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
