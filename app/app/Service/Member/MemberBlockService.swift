import Alamofire

final class MemberBlockService {

    static let shared = MemberBlockService()

    let session = Session(interceptor: AuthInterceptor())

    func add(targetId: Int64) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)/block"

        try await session.request(
            url,
            method: .post
        )
        .validateWithErrorHandling()
    }

    func remove(targetId: Int64) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)/block"

        try await session.request(
            url,
            method: .delete
        )
        .validateWithErrorHandling()
    }

    func gets(
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<MemberSettingResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/blocks"
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
