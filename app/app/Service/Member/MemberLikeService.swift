import Alamofire

final class MemberLikeService {

    static let shared = MemberLikeService()

    let session = Session(interceptor: AuthInterceptor())

    func add(targetId: Int64) async throws -> MemberLikeCountResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)/like"

        return try await session.request(
            url,
            method: .post
        )
        .decodingWithErrorHandling(MemberLikeCountResponse.self)
    }

    func cancel(targetId: Int64) async throws -> MemberLikeCountResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)/like"

        return try await session.request(
            url,
            method: .delete
        )
        .decodingWithErrorHandling(MemberLikeCountResponse.self)
    }

    func gets(
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<MemberSettingResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/likes"
        var params: Parameters = [
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
        .decodingWithErrorHandling(CursorResponse<MemberSettingResponse>.self)
    }
}
