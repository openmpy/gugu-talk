import SwiftUI
import Combine

@MainActor
final class RecentViewModel: ObservableObject {
    
    private let queryService = MemberQueryService.shared
    private let commandService = MemberCommandService.shared
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var hasNext: Bool = true
    
    @Published var comments: [MemberGetCommentResponse] = []
    
    private var cursorId: Int64?
    private var cursorDateAt: String?

    func fetchComments(gender: String) async {
        hasNext = true
        
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await queryService.getComments(
                gender: gender,
                cursorId: nil,
                cursorDateAt: nil,
                limit: 20
            )
            
            comments = response.payload
            cursorId = response.nextId
            cursorDateAt = response.nextDateAt
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
    
    func loadMoreComments(gender: String) async {
        guard !isLoading, hasNext else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await queryService.getComments(
                gender: gender,
                cursorId: cursorId,
                cursorDateAt: cursorDateAt,
                limit: 20
            )
            
            comments.append(contentsOf: response.payload)
            cursorId = response.nextId
            cursorDateAt = response.nextDateAt
            hasNext = response.hasNext
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
    
    func updateComment(comment: String) async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await commandService.updateComment(comment: comment)
            ToastManager.shared.show("코멘트를 작성하셨습니다.")
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
    
    func bumpComment() async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await commandService.bumpComment()
        } catch {
            errorMessage = error.localizedDescription
            ToastManager.shared.show(errorMessage ?? "알 수 없는 오류가 발생했습니다.", type: .error)
        }
    }
    
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
