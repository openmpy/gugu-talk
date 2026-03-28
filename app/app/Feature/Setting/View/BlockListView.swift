import SwiftUI

struct BlockListView: View {

    @StateObject private var vm = BlockListViewModel()

    var body: some View {
        VStack {
            if vm.blocks.isEmpty {
                Text("내역이 없습니다")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(vm.blocks) { it in
                            MemberSettingRowView(
                                nickname: it.nickname,
                                gender: it.gender,
                                age: it.age,
                                onDelete: {
                                    await vm.removeBlock(targetId: it.memberId)
                                })
                            .onAppear {
                                if it.id == vm.blocks.last?.id {
                                    Task {
                                        await vm.loadMoreBlocks()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await vm.fetchBlocks()
        }
        .loading(vm.isLoading)
        .navigationTitle("차단 목록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
