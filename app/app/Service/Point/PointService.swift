import Alamofire

final class PointService {

    static let shared = PointService()

    let session = Session(interceptor: AuthInterceptor())

    func earnByAttendance() async throws {
        let url = "\(NetworkConfig.baseURL)/v1/points/attendance"

        try await session.request(
            url,
            method: .post
        )
        .validateWithErrorHandling()
    }

    func earnByAdReward() async throws {
        let url = "\(NetworkConfig.baseURL)/v1/points/ad-reward"

        try await session.request(
            url,
            method: .post
        )
        .validateWithErrorHandling()
    }

    func get() async throws -> PointGetResponse {
        let url = "\(NetworkConfig.baseURL)/v1/points"

        return try await session.request(
            url,
            method: .get
        )
        .decodingWithErrorHandling(PointGetResponse.self)
    }
}
