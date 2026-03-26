import SwiftUI

struct MyProfileView: View {
    
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                MemberProfileImageView(images: vm.member.images)
                
                MemberProfileInfoView(
                    nickname: vm.member.nickname,
                    gender: vm.member.gender,
                    updatedAt: vm.member.updatedAt,
                    bio: vm.member.bio,
                    age: vm.member.age,
                    likes: vm.member.likes,
                    distance: vm.member.distance
                )
            }
            .task {
                await vm.get(targetId: AuthStore.shared.memberId ?? 0)
            }
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
}
