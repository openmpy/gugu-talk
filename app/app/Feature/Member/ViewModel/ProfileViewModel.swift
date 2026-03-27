import SwiftUI
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

    private let queryService = MemberQueryService.shared
    private let likeService = MemberLikeService.shared
    private let privatePhotoService = MemberPrivatePhotoService.shared
    private let blockService = MemberBlockService.shared
    private let chatRoomService = ChatRoomService.shared
    private let imageService = MemberImageService.shared

    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    @Published var member: MemberGetResponse = MemberGetResponse(
        memberId: 0,
        images: [],
        nickname: "",
        gender: "",
        age: 0,
        likes: 0,
        distance: nil,
        bio: nil,
        updatedAt: "",
        isChatEnabled: false,
        isLike: false,
        isPrivatePhoto: false,
        isOpenPrivatePhoto: false,
        isBlock: false
    )
    @Published var privateImages: [MemberPrivateImageResponse] = []

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

            member.likes = response.likes
            member.isLike = true
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

            member.likes = response.likes
            member.isLike = false
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

            member.isOpenPrivatePhoto = true
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

            member.isOpenPrivatePhoto = false
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

            member.isBlock = true
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

            member.isBlock = false
            ToastManager.shared.show("차단을 해제하셨습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }

    func sendMessage(targetId: Int64, content: String) async -> Bool {
        guard !isLoading else {
            return false
        }

        isLoading = true
        defer { isLoading = false }

        do {
            try await chatRoomService.create(targetId: targetId, content: content)
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }

    func getPrivateImages(targetId: Int64) async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await imageService.getPrivateImages(targetId: targetId)
            privateImages = response.images
            return true
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
            return false
        }
    }
}
