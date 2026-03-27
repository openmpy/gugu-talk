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

    func delete(chatRoomId: Int64) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms/\(chatRoomId)"

        try await session.request(
            url,
            method: .delete
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
            "limit": limit
        ]
        if cursorId != nil && cursorDateAt != nil {
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

    func getsUnread(
        cursorId: Int64?,
        cursorDateAt: String?,
        limit: Int
    ) async throws -> CompositeCursorResponse<ChatRoomGetResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms/unread"
        var params: Parameters = [
            "limit": limit
        ]
        if cursorId != nil && cursorDateAt != nil {
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
            "limit": limit
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

    func markAsRead(
        chatRoomId: Int64
    ) async throws {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms/\(chatRoomId)/read"

        try await session.request(
            url,
            method: .patch
        )
        .validateWithErrorHandlingForEmptyResponse()
    }

    func search(
        keyword: String,
        cursorId: Int64?,
        cursorDateAt: String?,
        limit: Int
    ) async throws -> CompositeCursorResponse<ChatRoomGetResponse> {
        let url = "\(NetworkConfig.baseURL)/v1/chat-rooms/search"
        var params: Parameters = [
            "keyword": keyword,
            "limit": limit
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
}
