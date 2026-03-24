import SwiftUI
import Kingfisher

struct MyProfileView: View {

    @StateObject private var vm = ProfileViewModel()

    @State private var images: [URL] = [
        URL(string: "https://picsum.photos/id/10/400/1000")!,
        URL(string: "https://picsum.photos/id/20/100/200")!,
        URL(string: "https://picsum.photos/id/30/400/300")!,
        URL(string: "https://picsum.photos/id/40/800/200")!,
        URL(string: "https://picsum.photos/id/50/50/50")!
    ]

    var body: some View {
        NavigationStack {
            Group {
                if let member = vm.member {
                    ScrollView(showsIndicators: false) {
                        TabView {
                            if images.isEmpty {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(100)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                            } else {
                                ForEach(images.indices, id: \.self) { index in
                                    NavigationLink {
                                        ImageFullCoverSlideView(images: images, startIndex: index)
                                    } label: {
                                        KFImage(images[index])
                                            .resizable()
                                            .placeholder {
                                                ProgressView()
                                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                    .background(Color(.systemGray4))
                                            }
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                            .background(.black)
                                            .clipped()
                                    }
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .aspectRatio(4/3, contentMode: .fit)
                        .clipped()

                        VStack(alignment: .leading, spacing: 15) {
                            Text(member.nickname)
                                .font(.title.bold())

                            HStack(alignment: .center) {
                                HStack {
                                    Text(member.gender == "MALE" ? "남자" : "여자")
                                    Text("·")
                                    Text("\(member.age)살")
                                    Text("·")
                                    Text("♥ \(member.likes)")
                                }
                                .font(.callout)
                                .foregroundColor(Color(.systemGray))
                            }
                            Text(member.bio ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding()
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                            } label: {
                                Text("편집")
                            }
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .task {
                await vm.get(targetId: AuthStore.shared.memberId ?? 0)
            }
            .navigationTitle("내 프로필")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
