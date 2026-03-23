import SwiftUI

struct MemberSearchView: View {

    @StateObject private var vm = MemberSearchViewModel()

    @State private var searchNickname: String = ""

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    if vm.members.isEmpty {
                        VStack(spacing: 8) {
                            Image(systemName: "person.slash")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)

                            Text("검색 결과가 없습니다")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(vm.members) { it in
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

                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text(it.nickname)
                                                .font(.headline.bold())
                                                .foregroundColor(it.gender == "MALE" ? .blue : .pink)

                                            Spacer()

                                            Text(it.updatedAt.relativeTime)
                                                .font(.caption)
                                                .foregroundColor(Color(.systemGray))
                                        }

                                        HStack {
                                            Text(it.gender == "MALE" ? "남자" : "여자")
                                            Text("·")
                                            Text("\(it.age)살")
                                            Text("·")
                                            Text("♥ \(it.likes)")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(Color(.systemGray))
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            }
                            .onAppear {
                                if it.id == vm.members.last?.id {
                                    Task {
                                        await vm.loadMoreMembers(nickname: searchNickname)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(
                text: $searchNickname,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "닉네임 입력"
            )
            .onSubmit(of: .search) {
                Task {
                    await vm.fetchMembers(nickname: searchNickname)
                }
            }
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
