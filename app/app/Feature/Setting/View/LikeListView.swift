import SwiftUI

struct LikeListView: View {

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<10) { i in
                        HStack(spacing: 12) {
                            Image(systemName: "person.fill")
                                .font(.title)
                                .frame(width: 55, height: 55)
                                .foregroundColor(Color(.systemGray6))
                                .background(Color(.systemGray4))
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text("닉네임")
                                    .font(.headline.bold())
                                    .foregroundColor(.primary)

                                HStack {
                                    Text("남자")
                                    Text("·")
                                    Text("20살")
                                }
                                .font(.footnote)
                                .foregroundColor(Color(.systemGray))
                            }

                            Spacer()

                            Button {

                            } label: {
                                Image(systemName: "trash.fill")
                                    .font(.default)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(.red)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle("좋아요 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    LikeListView()
}
