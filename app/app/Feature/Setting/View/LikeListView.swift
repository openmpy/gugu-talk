import SwiftUI

struct LikeListView: View {

    @StateObject private var vm = LikeListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    if vm.likes.isEmpty {
                        Text("내역이 없습니다")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    } else {
                        ForEach(vm.likes) { it in
                            MemberSettingRowView(
                                nickname: it.nickname,
                                gender: it.gender,
                                age: it.age,
                                onDelete: {
                                    await vm.unlike(targetId: it.memberId)
                                })
                            .onAppear {
                                if it.id == vm.likes.last?.id {
                                    Task {
                                        await vm.loadMoreLikes()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .task {
                await vm.fetchLikes()
            }
            .navigationTitle("좋아요 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
