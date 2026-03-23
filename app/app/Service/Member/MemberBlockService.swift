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
}
