import Alamofire

final class MemberSearchService {

    static let shared = MemberSearchService()

    let session = Session(interceptor: AuthInterceptor())

    func searchMembers(
        nickname: String,
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<MemberSearchNicknameResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/search"
        var params: Parameters = [
            "nickname": nickname,
            "limit": 20
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
        }

        return try await session.request(
            url,
            method: .get,
            parameters: params.compactMapValues { $0 }
        )
        .decodingWithErrorHandling(CursorResponse<MemberSearchNicknameResponse>.self)
    }
}
