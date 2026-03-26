import Alamofire

final class MemberCommandService {

    static let shared = MemberCommandService()

    let session = Session(interceptor: AuthInterceptor())

    func updateComment(comment: String) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/comments"
        let request = MemberUpdateCommentRequest(
            comment: comment
        )

        try await session.request(
            url,
            method: .put,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validateWithErrorHandling()
    }

    func bumpComment() async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/comments/bump"

        try await session.request(
            url,
            method: .put
        )
        .validateWithErrorHandling()
    }

    func updateLocation(
        longitude: Double?,
        latitude: Double?
    ) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/location"
        let request = MemberUpdateLocationRequest(
            longitude: longitude,
            latitude: latitude
        )

        try await session.request(
            url,
            method: .put,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validateWithErrorHandling()
    }

    func toogleChatEnabled(
        memberId: Int64
    ) async throws -> MemberGetChatEnabledResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/chat-enabled"

        return try await session.request(
            url,
            method: .put
        )
        .decodingWithErrorHandling(MemberGetChatEnabledResponse.self)
    }

    func updateProfile(
        nickname: String,
        birthYear: Int,
        bio: String?
    ) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members"
        let request = MemberUpdateProfileRequest(
            nickname: nickname,
            birthYear: birthYear,
            bio: bio
        )

        try await session.request(
            url,
            method: .put,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validateWithErrorHandling()
    }
}
