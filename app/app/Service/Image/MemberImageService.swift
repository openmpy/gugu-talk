import Alamofire

final class MemberImageService {

    static let shared = MemberImageService()

    let session = Session(interceptor: AuthInterceptor())

    func saveImages(request: MemberImageSaveRequest) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/images"

        try await session.request(
            url,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validateWithErrorHandlingForEmptyResponse()
    }

    func getPresignedUrl(type: String) async throws -> PresignedUrlResponse {
        let url = "\(NetworkConfig.baseURL)/v1/members/images/presigned-url"

        return try await session.request(
            url,
            method: .get,
            parameters: ["type": type]
        )
        .decodingWithErrorHandling(PresignedUrlResponse.self)
    }
}
