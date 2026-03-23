import SwiftUI

struct ProfileView: View {

    let memberId: Int64

    @StateObject private var vm = ProfileViewModel()

    @Namespace var namespace

    @State private var showMessage: Bool = false
    @State private var showSheet: Bool = false
    @State private var showBlock: Bool = false
    @State private var message: String = ""

    var body: some View {
        NavigationStack {
            Group {
                if let member = vm.member {
                    ScrollView(showsIndicators: false) {
                        TabView() {
                            ForEach(0..<5) { i in
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(100)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundColor(Color(.systemGray6))
                                    .background(Color(.systemGray4))
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .aspectRatio(4/3, contentMode: .fit)
                        .clipped()

                        VStack(alignment: .leading, spacing: 15) {
                            HStack(alignment: .center) {
                                Text(member.nickname)
                                    .font(.title.bold())

                                Spacer()

                                Text(member.updatedAt.relativeTime)
                                    .font(.callout)
                                    .foregroundColor(Color(.systemGray))
                            }
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

                                Spacer()

                                if let distance = member.distance {
                                    Text("\(distance)km")
                                        .font(.callout)
                                        .foregroundColor(Color(.systemGray))
                                }
                            }
                            Text(member.bio ?? "")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding()
                    }
                    .safeAreaInset(edge: .bottom) {
                        GlassEffectContainer {
                            HStack(spacing: 25) {
                                Button {
                                    Task {
                                        if member.isLike {
                                            await vm.unlike(targetId: memberId)
                                        } else {
                                            await vm.like(targetId: memberId)
                                        }
                                    }
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .frame(width: 60, height: 60)
                                        .font(.title)
                                        .foregroundColor(member.isLike ? .red : .gray)
                                        .glassEffect(.regular.interactive())
                                        .glassEffectUnion(id: 1, namespace: namespace)
                                }

                                Button {
                                    showMessage = true
                                } label: {
                                    Image(systemName: "message.fill")
                                        .frame(width: 60, height: 60)
                                        .font(.title)
                                        .foregroundColor(.blue)
                                        .glassEffect(.regular.interactive())
                                        .glassEffectUnion(id: 1, namespace: namespace)
                                }

                                Button {
                                    print("클릭")
                                } label: {
                                    Image(systemName: "photo.fill")
                                        .frame(width: 60, height: 60)
                                        .font(.title)
                                        .foregroundColor(member.isPrivatePhoto ? .green : .gray)
                                        .glassEffect(.regular.interactive())
                                        .glassEffectUnion(id: 1, namespace: namespace)
                                }
                                .disabled(!member.isPrivatePhoto)

                                Button {
                                    showBlock = true
                                } label: {
                                    Image(systemName: "nosign")
                                        .frame(width: 60, height: 60)
                                        .font(.title)
                                        .foregroundColor(member.isBlock ? .red : .gray)
                                        .glassEffect(.regular.interactive())
                                        .glassEffectUnion(id: 1, namespace: namespace)
                                }
                            }
                        }
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                showSheet = true
                            } label: {
                                Image(systemName: "ellipsis")
                            }
                            .confirmationDialog("메뉴", isPresented: $showSheet) {
                                Button(member.isOpenPrivatePhoto ? "비밀 사진 닫기" : "비밀 사진 열기") {
                                    Task {
                                        if member.isOpenPrivatePhoto {
                                            await vm.closePrivatePhoto(targetId: memberId)
                                        } else {
                                            await vm.openPrivatePhoto(targetId: memberId)
                                        }
                                    }
                                }
                                Button("신고하기", role: .destructive) {
                                }
                                Button("취소", role: .cancel) {}
                            }
                        }
                    }
                    .alert("쪽지", isPresented: $showMessage) {
                        TextField("내용 입력", text: $message)

                        Button("전송", role: .confirm) {
                            // 전송
                        }
                        Button("취소", role: .cancel) {
                            // 취소
                        }
                    }
                    .alert(member.isBlock ? "차단 해제" : "차단", isPresented: $showBlock) {
                        Button(member.isBlock ? "차단 해제" : "차단", role: .destructive) {
                            // 차단
                        }
                        Button("취소", role: .cancel) {
                            // 취소
                        }
                    } message: {
                        Text(member.isBlock
                             ? "차단을 해제하면 서로의 목록에서도 표시됩니다."
                             : "채팅 내역이 모두 삭제되며 서로의 목록에서도 표시되지 않습니다."
                        )
                    }
                } else {
                    ProgressView()
                }
            }
            .task {
                await vm.get(targetId: memberId)
            }
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}
