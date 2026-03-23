import Alamofire

final class MemberCommandService {

    static let shared = MemberCommandService()

    let session = Session(interceptor: AuthInterceptor())

    func bumpComment() async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/comments/bump"

        try await session.request(
            url,
            method: .put
        )
        .validateWithErrorHandling()
    }
}
