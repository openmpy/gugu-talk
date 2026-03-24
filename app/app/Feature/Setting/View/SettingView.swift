import SwiftUI

struct SettingView: View {

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    VStack(spacing: 0) {
                        NavigationLink {
                            MyProfileView()
                        } label : {
                            SettingSection(title: "내 프로필", icon: "person.crop.circle.fill", color: .blue)
                        }
                    }
                    .cornerRadius(12)

                    VStack(spacing: 0) {
                        NavigationLink {
                            LikeListView()
                        } label : {
                            SettingSection(title: "좋아요 목록", icon: "heart.fill", color: .red)
                        }
                        NavigationLink {
                            PrivatePhotoListView()
                        } label: {
                            SettingSection(title: "비밀 사진 목록", icon: "photo.fill", color: .green)
                        }
                        NavigationLink {
                            BlockListView()
                        } label: {
                            SettingSection(title: "차단 목록", icon: "nosign", color: .red)
                        }
                    }
                    .cornerRadius(12)

                    VStack(spacing: 0) {
                        SettingSection(title: "포인트", icon: "star.circle.fill", color: .yellow)
                        SettingSection(title: "출석 체크", icon: "calendar.circle.fill", color: .orange)
                        SettingSection(title: "광고 보상", icon: "gift.fill", color: .pink)
                    }
                    .cornerRadius(12)

                    VStack(spacing: 0) {
                        SettingSection(title: "공지사항", icon: "megaphone.fill", color: .teal)
                        SettingSection(title: "문의사항", icon: "envelope.fill", color: .indigo)
                        SettingSection(title: "서비스 이용약관", icon: "doc.text.fill", color: .gray)
                        SettingSection(title: "개인정보 취급방침", icon: "shield.fill", color: .green)
                    }
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(
                colorScheme == .light
                ? Color(uiColor: .systemGray6)
                : Color(uiColor: .systemBackground)
            )
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 회원 탈퇴
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
