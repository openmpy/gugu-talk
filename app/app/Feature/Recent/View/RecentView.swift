import SwiftUI

struct RecentView: View {

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
                    ForEach(0..<1000) { _ in
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

                                    Spacer()

                                    Text("방금 전")
                                        .font(.caption)
                                        .foregroundColor(Color(.systemGray))
                                }

                                Text("코멘트")
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
            .refreshable {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            .navigationTitle("최근")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // 검색
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // 코멘트 작성
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

#Preview {
    RecentView()
}
