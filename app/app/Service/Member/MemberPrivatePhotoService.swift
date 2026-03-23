import Alamofire

final class MemberPrivatePhotoService {

    static let shared = MemberPrivatePhotoService()

    let session = Session(interceptor: AuthInterceptor())

    func open(targetId: Int64) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)/private-photo"

        try await session.request(
            url,
            method: .post
        )
        .validateWithErrorHandling()
    }

    func close(targetId: Int64) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(targetId)/private-photo"
        
        try await session.request(
            url,
            method: .delete
        )
        .validateWithErrorHandling()
    }
}
