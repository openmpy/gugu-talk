import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    private let queryService = MemberQueryService.shared
    private let likeService = MemberLikeService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    @Published var member: MemberGetResponse?

    func get(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            member = try await queryService.get(targetId: targetId)
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func like(targetId: Int64) async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await likeService.add(targetId: targetId)

            if member != nil {
                member?.likes = response.likes
                member?.isLike = true
            }
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func unlike(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await likeService.cancel(targetId: targetId)

            if member != nil {
                member?.likes = response.likes
                member?.isLike = false
            }
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
