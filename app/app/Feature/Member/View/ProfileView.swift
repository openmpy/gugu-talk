import SwiftUI

struct ProfileView: View {
    
    let memberId: Int64
    
    @AppStorage("comment") private var saveComment: String?
    
    @StateObject private var vm = ProfileViewModel()
    
    @Namespace var namespace
    
    @State private var showMessage: Bool = false
    @State private var showSheet: Bool = false
    @State private var showBlock: Bool = false
    @State private var showReport: Bool = false
    @State private var message: String = ""
    @State private var goPrivatePhoto: Bool = false
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                MemberProfileImageView(images: vm.member.images)
                
                MemberProfileInfoView(
                    nickname: vm.member.nickname,
                    gender: vm.member.gender,
                    updatedAt: vm.member.updatedAt,
                    bio: vm.member.bio,
                    age: vm.member.age,
                    likes: vm.member.likes,
                    distance: vm.member.distance
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            profileActionView
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .task {
            await vm.get(targetId: memberId)
        }
        .navigationTitle("프로필")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "ellipsis")
                }
                .confirmationDialog("메뉴", isPresented: $showSheet) {
                    Button(vm.member.isOpenPrivatePhoto ? "비밀 사진 닫기" : "비밀 사진 열기") {
                        Task {
                            if vm.member.isOpenPrivatePhoto {
                                await vm.closePrivatePhoto(targetId: memberId)
                            } else {
                                await vm.openPrivatePhoto(targetId: memberId)
                            }
                        }
                    }
                    Button("신고하기", role: .destructive) {
                        showReport = true
                    }
                    Button("취소", role: .cancel) {}
                }
            }
        }
        .sheet(isPresented: $showReport) {
            ReportView(memberId: memberId)
                .presentationDetents([.medium, .large])
        }
        .navigationDestination(isPresented: $goPrivatePhoto) {
            PrivateImageFullCoverSlideView(
                images: vm.privateImages.compactMap { URL(string: $0.url) }
            )
        }
        .alert("쪽지", isPresented: $showMessage) {
            TextField("내용 입력", text: $message)
            
            Button("전송", role: .confirm) {
                if message.isEmpty {
                    ToastManager.shared.show("내용을 입력해주세요.", type: .error)
                    return
                }
                
                Task {
                    if await vm.sendMessage(targetId: memberId, content: message) == true {
                        saveComment = message
                        ToastManager.shared.show("쪽지가 전송되었습니다.")
                    }
                }
            }
            Button("취소", role: .cancel) { }
        }
        .alert(vm.member.isBlock ? "차단 해제" : "차단", isPresented: $showBlock) {
            Button(vm.member.isBlock ? "차단 해제" : "차단", role: .destructive) {
                Task {
                    if vm.member.isBlock {
                        await vm.removeBlock(targetId: memberId)
                    } else {
                        await vm.addBlock(targetId: memberId)
                    }
                }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text(vm.member.isBlock
                 ? "차단을 해제하면 서로의 목록에서도 표시됩니다."
                 : "채팅 내역이 모두 삭제되며 서로의 목록에서도 표시되지 않습니다."
            )
        }
    }
    
    // MARK: - Subview
    
    private var profileActionView: some View {
        GlassEffectContainer {
            HStack(spacing: 25) {
                Button {
                    Task {
                        if vm.member.isLike {
                            await vm.unlike(targetId: memberId)
                        } else {
                            await vm.like(targetId: memberId)
                        }
                    }
                } label: {
                    Image(systemName: "heart.fill")
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .foregroundColor(vm.member.isLike ? .red : .gray)
                        .glassEffect(.regular.interactive())
                        .glassEffectUnion(id: 1, namespace: namespace)
                }
                
                Button {
                    showMessage = true
                    message = saveComment ?? ""
                } label: {
                    Image(systemName: "message.fill")
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .foregroundColor(vm.member.isChatEnabled ? .blue : .gray)
                        .glassEffect(.regular.interactive())
                        .glassEffectUnion(id: 1, namespace: namespace)
                }
                .disabled(!vm.member.isChatEnabled)
                
                Button {
                    Task {
                        goPrivatePhoto = await vm.getPrivateImages(targetId: memberId)
                    }
                } label: {
                    Image(systemName: "photo.fill")
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .foregroundColor(vm.member.isPrivatePhoto ? .green : .gray)
                        .glassEffect(.regular.interactive())
                        .glassEffectUnion(id: 1, namespace: namespace)
                }
                .disabled(!vm.member.isPrivatePhoto)
                
                Button {
                    showBlock = true
                } label: {
                    Image(systemName: "nosign")
                        .frame(width: 60, height: 60)
                        .font(.title)
                        .foregroundColor(vm.member.isBlock ? .red : .gray)
                        .glassEffect(.regular.interactive())
                        .glassEffectUnion(id: 1, namespace: namespace)
                }
            }
        }
    }
}
