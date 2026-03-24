import SwiftUI

struct BlockListView: View {

    @StateObject private var vm = BlockListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 10) {
                    if vm.blocks.isEmpty {
                        Text("내역이 없습니다")
                            .foregroundColor(.secondary)
                            .padding(.vertical)
                    } else {
                        ForEach(vm.blocks) { it in
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 55, height: 55)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                                    .clipShape(Circle())

                                VStack(alignment: .leading) {
                                    Text(it.nickname)
                                        .font(.headline.bold())
                                        .foregroundColor(.primary)

                                    HStack {
                                        Text(it.gender == "MALE" ? "남자" : "여자")
                                        Text("·")
                                        Text("\(it.age)살")
                                    }
                                    .font(.footnote)
                                    .foregroundColor(Color(.systemGray))
                                }

                                Spacer()

                                Button {
                                    Task {
                                        await vm.removeBlock(targetId: it.memberId)
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .font(.default)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .background(.red)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .onAppear {
                                if it.id == vm.blocks.last?.id {
                                    Task {
                                        await vm.loadMoreBlocks()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .task {
                await vm.fetchBlocks()
            }
            .navigationTitle("차단 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
