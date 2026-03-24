import SwiftUI
import Combine

@MainActor
final class LocationViewModel: ObservableObject {

    private let commandService = MemberCommandService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func updateLocation(
        longitude: Double?,
        latitude: Double?
    ) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await commandService.updateLocation(
                longitude: longitude,
                latitude: latitude
            )
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
