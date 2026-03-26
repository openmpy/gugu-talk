import Alamofire

final class MemberSearchService {
    
    static let shared = MemberSearchService()
    
    let session = Session(interceptor: AuthInterceptor())
    
    func searchMembers(
        nickname: String,
        cursorId: Int64?,
        cursorDateAt: String?,
        limit: Int
    ) async throws -> CompositeCursorResponse<MemberSearchNicknameResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/search"
        var params: Parameters = [
            "nickname": nickname,
            "limit": limit
        ]
        if cursorId != nil && cursorDateAt != nil {
            params["cursorId"] = cursorId
            params["cursorDateAt"] = cursorDateAt
        }
        
        return try await session.request(
            url,
            method: .get,
            parameters: params.compactMapValues { $0 }
        )
        .decodingWithErrorHandling(CompositeCursorResponse<MemberSearchNicknameResponse>.self)
    }
}
