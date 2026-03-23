import SwiftUI

struct ProfileView: View {
    
    @Namespace var namespace
    
    @State private var showMessage: Bool = false
    @State private var showSheet: Bool = false
    @State private var showBlock: Bool = false
    @State private var message: String = ""
    
    var body: some View {
        NavigationStack {
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
                        Text("닉네임")
                            .font(.title.bold())
                        
                        Spacer()
                        
                        Text("방금 전")
                            .font(.callout)
                            .foregroundColor(Color(.systemGray))
                    }
                    HStack(alignment: .center) {
                        HStack {
                            Text("남자")
                            Text("·")
                            Text("20살")
                            Text("·")
                            Text("♥ 100")
                        }
                        .font(.callout)
                        .foregroundColor(Color(.systemGray))
                        
                        Spacer()
                        
                        Text("12.3km")
                            .font(.callout)
                            .foregroundColor(Color(.systemGray))
                    }
                    Text("자기소개")
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
                        } label: {
                            Image(systemName: "heart.fill")
                                .frame(width: 60, height: 60)
                                .font(.title)
                                .foregroundColor(.gray)
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
                        } label: {
                            Image(systemName: "photo.fill")
                                .frame(width: 60, height: 60)
                                .font(.title)
                                .foregroundColor(.gray)
                                .glassEffect(.regular.interactive())
                                .glassEffectUnion(id: 1, namespace: namespace)
                        }
                        Button {
                            showBlock = true
                        } label: {
                            Image(systemName: "nosign")
                                .frame(width: 60, height: 60)
                                .font(.title)
                                .foregroundColor(.gray)
                                .glassEffect(.regular.interactive())
                                .glassEffectUnion(id: 1, namespace: namespace)
                        }
                    }
                }
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
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
                        Button("비밀 사진 열기") {
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
            .alert("차단", isPresented: $showBlock) {
                Button("차단", role: .destructive) {
                    // 차단
                }
                Button("취소", role: .cancel) {
                    // 취소
                }
            } message: {
                Text("채팅 내역이 모두 삭제되며 서로의 목록에서도 표시되지 않습니다.")
            }
        }
    }
}

#Preview {
    ProfileView()
}
