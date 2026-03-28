import SwiftUI

struct PointView: View {

    @StateObject private var vm = PointViewModel()

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Text("보유 포인트")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(String(format: "%@ P", vm.point.formatted()))
                    .font(.largeTitle.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.yellow.opacity(0.5))
            )
            .padding(.bottom)

            BannerAdView(adUnitID: "ca-app-pub-3940256099942544/2934735716")
                .frame(height: 250)

            Spacer()
        }
        .padding()
        .task {
            await vm.get()
        }
        .loading(vm.isLoading)
        .navigationTitle("포인트")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
