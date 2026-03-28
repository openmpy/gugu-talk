import SwiftUI

struct MyProfileView: View {

    @StateObject private var vm = ProfileViewModel()

    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                MemberProfileImageView(images: vm.member.images)

                MemberProfileInfoView(
                    nickname: vm.member.nickname,
                    gender: vm.member.gender,
                    updatedAt: nil,
                    bio: vm.member.bio,
                    age: vm.member.age,
                    likes: vm.member.likes,
                    distance: nil
                )
            }
        }
        .task {
            await vm.get(targetId: AuthStore.shared.memberId ?? 0)
        }
        .loading(vm.isLoading)
        .navigationTitle("내 프로필")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ProfileEditView()
                } label: {
                    Text("편집")
                }
            }
        }
    }
}
