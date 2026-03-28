import SwiftUI

struct PrivatePhotoListView: View {

    @StateObject private var vm = PrivatePhotoListViewModel()

    var body: some View {
        VStack {
            if vm.photos.isEmpty {
                Text("내역이 없습니다")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 10) {
                        ForEach(vm.photos) { it in
                            MemberSettingRowView(
                                nickname: it.nickname,
                                gender: it.gender,
                                age: it.age,
                                onDelete: {
                                    await vm.closePhoto(targetId: it.memberId)
                                })
                            .onAppear {
                                if it.id == vm.photos.last?.id {
                                    Task {
                                        await vm.loadMorePhotos()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await vm.fetchPhotos()
        }
        .loading(vm.isLoading)
        .navigationTitle("비밀 사진 목록")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
