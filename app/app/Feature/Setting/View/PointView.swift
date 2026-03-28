import SwiftUI

struct PointView: View {

    @StateObject private var vm = PointViewModel()

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Text("보유 포인트")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text("\(vm.point) P")
                    .font(.largeTitle.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.yellow.opacity(0.5))
            )
            .padding()

            Spacer()
        }
        .task {
            await vm.get()
        }
        .navigationTitle("포인트")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
