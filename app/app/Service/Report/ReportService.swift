import Alamofire

final class ReportService {

    static let shared = ReportService()

    let session = Session(interceptor: AuthInterceptor())

    func save(reportedId: Int64, request: ReportSaveRequest) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/members/\(reportedId)/report"

        try await session.request(
            url,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validateWithErrorHandling()
    }
}
