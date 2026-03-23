import SwiftUI

struct MemberSearchView: View {
    
    @State private var searchNickname: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<1000) { i in
                        NavigationLink {
                            ProfileView()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text("닉네임")
                                            .font(.headline.bold())
                                            .foregroundColor(i % 2 == 0 ? .blue : .pink)

                                        Spacer()
                                        
                                        Text("방금 전")
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                    
                                    HStack {
                                        Text("남자")
                                        Text("·")
                                        Text("20살")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .searchable(
                text: $searchNickname,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "닉네임 입력"
            )
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("회원 검색")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

#Preview {
    MemberSearchView()
}
