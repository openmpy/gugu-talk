import SwiftUI
import Combine

@MainActor
final class LoginViewModel: ObservableObject {

    private let service = AuthService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func login(
        phone: String,
        password: String
    ) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.login(
                phone: phone,
                password: password
            )

            AuthStore.shared.memberId = response.memberId
            AuthStore.shared.accessToken = response.accessToken
            AuthStore.shared.refreshToken = response.refreshToken
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }
}
