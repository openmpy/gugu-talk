import SwiftUI
import Combine

@MainActor
final class SignupViewModel: ObservableObject {

    private let service = AuthService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    func sendVerificationCode(phone: String) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            try await service.sendVerificationCode(
                phone: phone
            )
            ToastManager.shared.show("인증 번호가 발송되었습니다.")
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }

    func signup(
        verificationCode: String,
        phone: String,
        password: String,
        gender: String
    ) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await service.signup(
                uuid: UUID.init().uuidString,
                verificationCode: verificationCode,
                phone: phone,
                password: password,
                gender: gender
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
