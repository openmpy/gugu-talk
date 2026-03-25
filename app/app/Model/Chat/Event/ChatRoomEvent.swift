struct ChatRoomEvent: Codable {

    let type: String
    let chatRoomId: Int64
    let memberId: Int64?
    let thumbnail: String?
    let nickname: String?
    let lastMessage: String?
    let lastMessageAt: String?
    let unreadCount: Int64?
    let isNew: Bool?
}
