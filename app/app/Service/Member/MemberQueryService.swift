import Alamofire

final class MemberQueryService {

    static let shared = MemberQueryService()

    let session = Session(interceptor: AuthInterceptor())

    func getComments(
        gender: String,
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<MemberGetCommentResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/comments"
        var params: Parameters = [
            "gender": gender,
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
        .decodingWithErrorHandling(CursorResponse<MemberGetCommentResponse>.self)
    }

    func getLocations(
        gender: String,
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<MemberGetLocationResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/locations"
        var params: Parameters = [
            "gender": gender,
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
        .decodingWithErrorHandling(CursorResponse<MemberGetLocationResponse>.self)
    }

    func get(
        targetId: Int64
    ) async throws -> MemberGetResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)"

        return try await session.request(
            url,
            method: .get
        )
        .decodingWithErrorHandling(MemberGetResponse.self)
    }

    func getChatEnabled(
        memberId: Int64
    ) async throws -> MemberGetChatEnabledResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/chat-enabled"

        return try await session.request(
            url,
            method: .get
        )
        .decodingWithErrorHandling(MemberGetChatEnabledResponse.self)
    }
}
