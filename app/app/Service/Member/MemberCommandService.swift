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
}
