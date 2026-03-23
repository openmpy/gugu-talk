import SwiftUI
import Combine

@MainActor
final class ProfileSetupViewModel: ObservableObject {

    private let service = AuthService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func setup(
        nickname: String,
        birthYear: Int,
        bio: String
    ) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            try await service.setup(
                nickname: nickname,
                birthYear: birthYear,
                bio: bio
            )
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }
}
