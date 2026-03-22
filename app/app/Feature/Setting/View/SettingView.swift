import SwiftUI

struct SettingView: View {

    var body: some View {
        NavigationStack {
            VStack {
                Text("설정")
            }
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
    RecentView()
}
