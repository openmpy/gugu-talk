import SwiftUI
import SimpleToast
import GoogleMobileAds

@main
struct GuguApp: App {

    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false

    @StateObject private var toast = ToastManager.shared
    @StateObject private var stomp = StompManager.shared

    private let toastOptions = SimpleToastOptions(alignment: .bottom, hideAfter: 5)

    init() {
        MobileAds.shared.start()
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoggedIn {
                    ContentView()
                        .onAppear {
                            stomp.connect(accessToken: AuthStore.shared.accessToken ?? "")
                        }
                } else {
                    LoginView()
                }
            }
            .simpleToast(isPresented: $toast.isShow, options: toastOptions) {
                if let data = toast.toast {
                    Label(data.message, systemImage: data.type == .error
                          ? "xmark.circle.fill"
                          : "checkmark.circle.fill"
                    )
                    .padding()
                    .background(data.type == .error ? Color.red.opacity(0.8) : Color.blue.opacity(0.8))
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom, 90)
                }
            }
        }
    }
}
