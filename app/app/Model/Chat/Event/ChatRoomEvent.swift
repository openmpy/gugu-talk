struct ChatRoomEvent: Codable {

    let type: String
    let chatRoomId: Int64
    let lastMessage: String?
    let lastMessageAt: String?
}
