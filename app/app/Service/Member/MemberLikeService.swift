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
}
