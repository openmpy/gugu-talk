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
                            SettingSectionView(title: "내 프로필", icon: "person.crop.circle.fill", color: .blue)
                        }
                    }
                    .cornerRadius(12)
                    
                    VStack(spacing: 0) {
                        NavigationLink {
                            LikeListView()
                        } label : {
                            SettingSectionView(title: "좋아요 목록", icon: "heart.fill", color: .red)
                        }
                        NavigationLink {
                            PrivatePhotoListView()
                        } label: {
                            SettingSectionView(title: "비밀 사진 목록", icon: "photo.fill", color: .green)
                        }
                        NavigationLink {
                            BlockListView()
                        } label: {
                            SettingSectionView(title: "차단 목록", icon: "nosign", color: .red)
                        }
                    }
                    .cornerRadius(12)
                    
                    VStack(spacing: 0) {
                        SettingSectionView(title: "포인트", icon: "star.circle.fill", color: .yellow)
                        SettingSectionView(title: "출석 체크", icon: "calendar.circle.fill", color: .orange)
                        SettingSectionView(title: "광고 보상", icon: "gift.fill", color: .pink)
                    }
                    .cornerRadius(12)
                    
                    VStack(spacing: 0) {
                        SettingSectionView(title: "공지사항", icon: "megaphone.fill", color: .teal)
                        SettingSectionView(title: "문의사항", icon: "envelope.fill", color: .indigo)
                        SettingSectionView(title: "서비스 이용약관", icon: "doc.text.fill", color: .gray)
                        SettingSectionView(title: "개인정보 취급방침", icon: "shield.fill", color: .green)
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
