import SwiftUI

struct LocationView: View {

    var body: some View {
        NavigationStack {
            VStack {
                Text("위치")
            }
            .navigationTitle("위치")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // 검색
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}

#Preview {
    RecentView()
}
