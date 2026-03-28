import SwiftUI
import Combine

@MainActor
final class PointViewModel: ObservableObject {

    private let service = PointService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    @Published var point: Int64 = 0
    
    func get() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.get()
            point = response.point
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
