import SwiftUI

struct LoadingModifier: ViewModifier {

    let isLoading: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isLoading {
                Color(.systemBackground).opacity(0.2).ignoresSafeArea()

                ProgressView()
                    .tint(.primary)
            }
        }
    }
}

extension View {

    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}
