import Alamofire

final class MemberCommandService {

    static let shared = MemberCommandService()

    let session = Session(interceptor: AuthInterceptor())

    func updateComment(comment: String) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/comments"
        let request = MemberUpdateCommentRequest(
            comment: comment
        )

        return try await session.request(
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
}
