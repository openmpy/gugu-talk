import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    private let queryService = MemberQueryService.shared
    private let likeService = MemberLikeService.shared
    private let privatePhotoService = MemberPrivatePhotoService.shared
    private let blockService = MemberBlockService.shared

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

    func openPrivatePhoto(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await privatePhotoService.open(targetId: targetId)

            if member != nil {
                member?.isOpenPrivatePhoto = true
            }
            ToastManager.shared.show("비밀 사진을 공개하셨습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func closePrivatePhoto(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await privatePhotoService.close(targetId: targetId)

            if member != nil {
                member?.isOpenPrivatePhoto = false
            }
            ToastManager.shared.show("비밀 사진 공개를 닫으셨습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func addBlock(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await blockService.add(targetId: targetId)

            if member != nil {
                member?.isBlock = true
            }
            ToastManager.shared.show("차단하셨습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func removeBlock(targetId: Int64) async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await blockService.remove(targetId: targetId)

            if member != nil {
                member?.isBlock = false
            }
            ToastManager.shared.show("차단을 해제하셨습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
}
