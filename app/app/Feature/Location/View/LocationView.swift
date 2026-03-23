import SwiftUI

struct LocationView: View {
    
    @State private var selectGender: String = "전체"
    
    var body: some View {
        NavigationStack {
            Picker("성별", selection: $selectGender) {
                Text("전체").tag("전체")
                Text("여자").tag("여자")
                Text("남자").tag("남자")
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    ForEach(0..<1000) { i in
                        NavigationLink {
                            ProfileView(memberId: 1)
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("닉네임")
                                            .font(.headline.bold())
                                            .foregroundColor(i % 2 == 0 ? .blue : .pink)
                                        
                                        Spacer()
                                        
                                        Text("방금 전")
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                    
                                    Text("자기소개")
                                        .lineLimit(1)
                                        .font(.subheadline)
                                        .foregroundColor(Color(.systemGray))
                                    
                                    HStack {
                                        HStack {
                                            Text("남자")
                                            Text("·")
                                            Text("20살")
                                            Text("·")
                                            Text("♥ 100")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(Color(.systemGray))
                                        
                                        Spacer()
                                        
                                        Text("12.3km")
                                            .font(.caption)
                                            .foregroundColor(Color(.systemGray))
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                    }
                }
            }
            .refreshable {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            .navigationTitle("위치")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        MemberSearchView()
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
