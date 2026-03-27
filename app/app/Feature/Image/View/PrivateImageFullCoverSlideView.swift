import SwiftUI
import Kingfisher
import Zoomable

struct PrivateImageFullCoverSlideView: View {

    let images: [URL]

    @State private var showAlert: Bool = false
    @State private var currentIndex: Int = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            SecureView {
                TabView(selection: $currentIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        KFImage(images[index])
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .zoomable()
                    }
                }
                .tabViewStyle(PageTabViewStyle())
            }
        }
        .onAppear {
            showAlert = true
        }
        .alert("경고", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("비밀 사진을 캡처할 시 서비스 이용이 제한됩니다.")
        }
    }
}
