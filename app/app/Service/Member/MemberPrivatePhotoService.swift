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
    
    func gets(
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<MemberSettingResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/members/private-photos"
        var params: Parameters = [
            "limit": 20
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
        }
        
        return try await session.request(
            url,
            method: .get,
            parameters: params.compactMapValues { $0 }
        )
        .decodingWithErrorHandling(CursorResponse<MemberSettingResponse>.self)
    }
}
