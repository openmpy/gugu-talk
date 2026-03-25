import Alamofire

final class ChatRoomService {

    static let shared = ChatRoomService()

    let session = Session(interceptor: AuthInterceptor())

    func create(targetId: Int64, content: String) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms?targetId=\(targetId)"
        let request = ChatRoomCreateRequest(
            content: content
        )

        try await session.request(
            url,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default
        )
        .validateWithErrorHandlingForEmptyResponse()
    }

    func gets(
        cursorId: Int64?,
        cursorDateAt: String?,
        limit: Int
    ) async throws -> CompositeCursorResponse<ChatRoomGetResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms"
        var params: Parameters = [
            "limit": 20
        ]
        if let cursorId = cursorId {
            params["cursorId"] = cursorId
            params["cursorDateAt"] = cursorDateAt
        }

        return try await session.request(
            url,
            method: .get,
            parameters: params.compactMapValues { $0 }
        )
        .decodingWithErrorHandling(CompositeCursorResponse<ChatRoomGetResponse>.self)
    }

    func get(
        chatRoomId: Int64,
        cursorId: Int64?,
        limit: Int
    ) async throws -> CursorResponse<ChatMessageGetResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms/\(chatRoomId)"
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
        .decodingWithErrorHandling(CursorResponse<ChatMessageGetResponse>.self)
    }
}
