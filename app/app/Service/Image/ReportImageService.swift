import Alamofire

final class ReportImageService {
    
    static let shared = ReportImageService()
    
    let session = Session(interceptor: AuthInterceptor())
    
    func getPresignedUrl(reportedId: Int64) async throws -> PresignedUrlResponse {
        let url = "\(NetworkConfig.baseURL)/v1/reports/\(reportedId)/presigned-url"
        
        return try await session.request(
            url,
            method: .get
        )
        .decodingWithErrorHandling(PresignedUrlResponse.self)
    }
}
